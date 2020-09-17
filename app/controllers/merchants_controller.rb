class MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def new
  end

  def create
    merchant = Merchant.create(merchant_params)
    if merchant.save
      redirect_to merchants_path
    else
      flash[:error] = merchant.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])
    if params[:toggle_status]
      @merchant.toggle_status
      if @merchant.active?
        @merchant.enable_items
        flash[:success] = "#{@merchant.name} is now enabled"
      else
        @merchant.disable_items
        flash[:success] = "#{@merchant.name} is now disabled"
      end
      redirect_to admin_merchants_path
    else 
      @merchant.update(merchant_params)
      if @merchant.save
        redirect_to "/merchants/#{@merchant.id}"
      else
        flash[:error] = @merchant.errors.full_messages.to_sentence
        render :edit
      end
    end
  end

  def destroy
    Merchant.destroy(params[:id])
    redirect_to '/merchants'
  end

  private

  def merchant_params
    params.permit(:name,:address,:city,:state,:zip)
  end
end
