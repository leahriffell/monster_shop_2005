class Merchant::ItemsController < Merchant::BaseController
  def index
    @merchant = Merchant.find(current_user.merchant_id)
    @items = Item.where(merchant_id: current_user.merchant_id)
  end
end
