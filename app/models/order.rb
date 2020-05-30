class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders

  enum status: %w(default pending)

  def grandtotal
    item_orders.sum('price * quantity')
  end
end
