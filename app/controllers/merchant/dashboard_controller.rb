class Merchant::DashboardController < Merchant::BaseController
  before_action :require_merchant

  def index
    @pending_orders = []
    @pending_items = []
    @pending_item_orders = []
    @merchant = Merchant.find(current_user.merchant_id)
    @orders = Order.all
    @item_orders = ItemOrder.all
    @all_merchant_items = Item.where(merchant_id: current_user.merchant_id)
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

  def items
    @items = Item.where(merchant_id: current_user.merchant_id)
  end

end
