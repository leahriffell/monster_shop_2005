class Admin::DashboardController < Admin::BaseController

  def index
  end

  def merchant
    @merchant = Merchant.find(params[:merchant_id])
    # Eventually we want to be able to call something like below
      # @orders = @merchant.orders

    @pending_orders = []
    @pending_items = []
    @pending_item_orders = []
    @orders = Order.all
    @item_orders = ItemOrder.all
    @all_merchant_items = Item.where(merchant_id:@merchant.id)
    @all_merchant_items.each do |item|
      @item_orders.each do |item_order|
        if item.id == item_order.item_id
          @orders.each do |order|
            if order.id == item_order.order_id
              @pending_orders << order
              @pending_items << item
              @pending_item_orders << item_order
            end
          end
        end
      end
    end
    @pending_data = @pending_orders.zip(@pending_items.zip(@pending_item_orders))
  end

  def merchant_items
    @merchant = Merchant.find(params[:merchant_id])
    @items = Item.where(merchant_id:@merchant.id)
  end

end
