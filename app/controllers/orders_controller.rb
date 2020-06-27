class OrdersController < ApplicationController

  def index
    @orders = Order.where(user_id: current_user[:id])
  end

  def new
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    params[:user_id] = current_user.id
    order = Order.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      flash[:success] = "Your order has been created"
      session.delete(:cart)
      redirect_to "/orders/#{order.id}"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def update
    order = Order.find_by(id: params[:id])
    order.cancel_order
    order.update(status: "cancelled")
    flash[:success] = "Order #{order.id} has been cancelled."
    redirect_to "/profile"
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip, :user_id)
  end
end
