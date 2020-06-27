require 'rails_helper'

RSpec.describe "Admin view of user profile page" do
  before(:each) do
    login_admin
    @user = User.create(name: "Willy Wonka", address: "123 St", city: "Denver", state: "CO", zip: "12345", email: "chocolateguy1@gmail.com", password: "loco123", role: 0)
  end

  it "displays data a user would see" do

    visit "admin/profile/#{@user.id}"

    expect(page).to have_content("Welcome, #{@user.name}")
    expect(page).to have_link("Log out")
    expect(page).to have_content(@user.name)
    expect(page).to have_content(@user.email)
    expect(page).to have_content(@user.address)
    expect(page).to have_content(@user.city)
    expect(page).to have_content(@user.state)
    expect(page).to have_content(@user.zip)
    expect(page).to have_content(@user.email)
    expect(page).to_not have_link("Edit My Profile")
  end

  it "displays link for orders if orders have been placed" do
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    order = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: @user.id)
    ItemOrder.create!(order_id: order.id, price: 1.0, item_id: dog_bone.id, quantity: 5)
    ItemOrder.create!(order_id: order.id, price: 1.0, item_id: pull_toy.id, quantity: 1)
    ItemOrder.create!(order_id: order.id, price: 1.0, item_id: tire.id, quantity: 4)
    visit "admin/profile/#{@user.id}"
    click_link("My Orders")
    expect(current_path).to eq('/orders')
  end

end
