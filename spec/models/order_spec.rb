require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "enum" do
    it { should define_enum_for(:status).with_values([:pending, :packaged, :shipped, :cancelled]) }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
    it {should belong_to(:user)}
  end

  describe 'instance methods' do
    before :each do
      login_user
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user.id)

      @item_order1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @item_order2 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it '#grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it '#quantity_sum_per_merchant' do
      expect(@order_1.quantity_sum_per_merchant(@meg)).to eq(2)
    end

    it '#value_sum_per_merchant' do
      expect(@order_1.value_sum_per_merchant(@meg)).to eq(200)
    end

    it "#quantity_sum" do
      expect(@order_1.quantity_sum).to eq(5)
    end

    it "#totally_fulfilled?" do
      expect(@order_1.totally_fulfilled?).to eq(false)

      @item_order1.update(fulfilled?: true)
      @item_order2.update(fulfilled?: true)

      expect(@order_1.totally_fulfilled?).to eq(true)
    end

    it "#cancel_order" do
      @order_1.cancel_order
      @order_1.reload
      expect(@order_1.status).to eq("cancelled")
    end

  end

  describe 'class methods' do
    before :each do
      login_user
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user.id)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
      @order = Order.create!(name: "Easier", address: "Way", city: "Town", state: "OK", zip: 90210, user_id: @user.id, status: 1)
    end

    it '.find_order' do
      expect(Order.find_order(@order_1.id)).to eq(@order_1)
    end

    it ".pending_orders" do
      expect(Order.pending_orders).to eq([@order_1])
    end
  end

end
