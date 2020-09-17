class OrdersController <ApplicationController

  def new

  end

  def show
    @order = Order.find(params[:id])
    require 'pry'; binding.pry
  end

  def create
    order = current_user.orders.new(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      if current_user.role == "regular" || current_user.role == "merchant"
        flash[:success] = "Your order was created!"
        redirect_to profile_orders_path
      end
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
