require 'rails_helper'

RSpec.describe "User profile page" do
  before(:each) do
    @regular_user = User.create(name: "Willy Wonka", address: "123 St", city: "Denver", state: "CO", zip: "12345", email: "chocolateguy1@gmail.com", password: "loco123", role: 0)
  end
  it "displays current user data and edit info link" do

    visit '/login'

    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_on "Login!"

    expect(current_path).to eq('/profile')

    expect(page).to have_content("Welcome, #{@regular_user.name}")
    expect(page).to have_link("Log out")
    expect(page).to have_content(@regular_user.name)
    expect(page).to have_content(@regular_user.email)
    expect(page).to have_content(@regular_user.address)
    expect(page).to have_content(@regular_user.city)
    expect(page).to have_content(@regular_user.state)
    expect(page).to have_content(@regular_user.zip)
    expect(page).to have_content(@regular_user.email)
    expect(page).to have_link("Edit My Profile")

    expect(page).to_not have_content(@regular_user.password)
    expect(page).to_not have_link("Sign up")
    expect(page).to_not have_link("Sign in")
  end

  it "Allows user to edit profile info" do
    visit '/login'

    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_on "Login!"

    expect(current_path).to eq('/profile')
    click_link("Edit My Profile")
    expect(current_path).to eq('/profile/edit')

   expect(page).to have_field(:name, :with => @regular_user.name)
   expect(page).to have_field(:address, :with => @regular_user.address)
   expect(page).to have_field(:city, :with => @regular_user.city)
   expect(page).to have_field(:state, :with => @regular_user.state)
   expect(page).to have_field(:zip, :with => @regular_user.zip)
   expect(page).to have_field(:email, :with => @regular_user.email)
   expect(page).to_not have_field(:password)

    fill_in :city, with: "Boston"
    fill_in :state, with: "MA"
    fill_in :zip, with: "12345"
    click_button("Submit")
    expect(current_path).to eq('/profile')
    expect(page).to have_content("Your data has been updated.")
    expect(page).to have_content(@regular_user.name)
    expect(page).to have_content(@regular_user.email)
    expect(page).to have_content(@regular_user.address)
    expect(@regular_user.reload.city).to eq ("Boston")

    expect(page).to have_content("Boston")
    expect(page).to have_content("MA")
    expect(page).to have_content("12345")
    expect(page).to have_content(@regular_user.email)
  end

  it "Allows user to update their password" do
    visit '/login'

    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_on "Login!"

    expect(current_path).to eq('/profile')
    click_link("Edit My Password")
    expect(current_path).to eq('/password/edit')

    fill_in :password, with: "hellokitty"
    fill_in :password_confirmation, with: "hellokitty"
    click_button("Submit")
    expect(current_path).to eq('/profile')
    expect(page).to have_content("Your password has been updated.")

  end

  it "Denies ability to update email address to one that is already in use" do
    User.create(name: "Fake Willy", address: "123 St", city: "Boulder", state: "CO", zip: "12346", email: "wannabechocolateguy1@gmail.com", password: "loco321", role: 0)

    visit '/login'

    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_on "Login!"

    expect(current_path).to eq('/profile')
    click_link("Edit My Profile")
    expect(current_path).to eq('/profile/edit')

    fill_in :email, with: "wannabechocolateguy1@gmail.com"
    click_button("Submit")

    expect(current_path).to eq('/profile/edit')
    expect(page).to have_content("Email address is already in use.")
  end

  it "displays link for orders if orders have been placed" do
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    order = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: @regular_user.id)
    ItemOrder.create!(order_id: order.id, price: 1.0, item_id: dog_bone.id, quantity: 5)
    ItemOrder.create!(order_id: order.id, price: 1.0, item_id: pull_toy.id, quantity: 1)
    ItemOrder.create!(order_id: order.id, price: 1.0, item_id: tire.id, quantity: 4)

    visit '/login'

    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_on "Login!"

    expect(current_path).to eq('/profile')
    click_link("My Orders")
    expect(current_path).to eq('/orders')
  end
end
