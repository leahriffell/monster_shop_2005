class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:id])
    # passing type of update below in if statement in case we need to update other attributes of merchant 
    if params[:toggle_status]
      merchant.toggle(:active?).save
      flash[:success] = "#{merchant.name} is now disabled"
      redirect_to admin_merchants_path
    end
  end
end