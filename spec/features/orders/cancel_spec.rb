require 'rails_helper'

RSpec.describe "Orders show page, cancel button" do
  before(:each) do
    @regular_user = User.create(name: "Willy Wonka", address: "123 St", city: "Denver", state: "CO", zip: "12345", email: "chocolateguy1@gmail.com", password: "loco123", role: 0)
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @maude = @dog_shop.users.create!(name: "Maude Sloggett", address: "17 Sun Rise St", city: "El Paso", state: "Illinois", zip: "56726", email: "M.Slogget@yahoo.com", password: "Forever27", role: 1)
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @order1 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: @regular_user.id)
    @order2 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: @regular_user.id)
    @itemorder1 = ItemOrder.create!(order_id: @order1.id, price: 1.0, item_id: @dog_bone.id, quantity: 5)
    @itemorder2 = ItemOrder.create!(order_id: @order1.id, price: 1.0, item_id: @pull_toy.id, quantity: 1)
    @itemorder3 = ItemOrder.create!(order_id: @order2.id, price: 1.0, item_id: @tire.id, quantity: 4)

    visit '/login'
    fill_in :email, with: @maude.email
    fill_in :password, with: @maude.password
    click_on "Login!"

    visit "/merchant/orders/#{@order1.id}"

    within "#item-#{@dog_bone.id}" do
      click_on "fulfill item"
    end

    within "#item-#{@pull_toy.id}" do
      click_on "fulfill item"
    end

    click_on "Log out"

    visit '/login'
    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_on "Login!"

    visit "/orders/#{@order1.id}"

    click_on "Cancel Order"
  end

  it "has cancel button" do
    expect(current_path).to eq("/profile")
    expect(page).to have_content("Order #{@order1.id} has been cancelled.")
  end

  it "cancelled order items status is unfulfilled" do
    expect(@itemorder1.fulfilled?).to eq(false)
    expect(@itemorder2.fulfilled?).to eq(false)
  end

  it "item quantities that were fulfilled are returned to merchants inventory" do
    expect(@dog_bone.inventory).to eq(21)
    expect(@pull_toy.inventory).to eq(32)
  end

  it "order status is cancelled" do
    @order1.reload 
    expect(@order1.status).to eq("cancelled")
  end

end
