class CartController < Cart::BaseController
  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    if cart.contents[item.id] == 0
      cart.contents.clear
      flash[:failure] = "There are limited supplies in inventory - this item has reached it's max! Please try again later."
    else
      flash[:success] = "#{item.name} was successfully added to your cart"
      redirect_to "/items"
    end
  end

  def show
    @items = cart.items
  end

  def update_quantity
    item = Item.find(params[:item_id])
    binding.pry
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end


end
