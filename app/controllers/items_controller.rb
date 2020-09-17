class ItemsController<ApplicationController

  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
      @popular_items = @merchant.items.by_popularity(sum_qty: :desc)
      @least_popular_items = @merchant.items.by_popularity(:sum_qty)
    else
      @items = Item.active_items
      @popular_items = Item.by_popularity(sum_qty: :desc)
      @least_popular_items = Item.by_popularity(:sum_qty)
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    item = @merchant.items.create(item_params)
    if item.save
      redirect_to "/merchants/#{@merchant.id}/items"
    else
      flash[:error] = item.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if params[:change_inactive]
      @item.toggle_active
      flash[:success] = "#{@item.name} is no longer for sale"
      redirect_to merchant_items_path
    elsif params[:change_active]
      @item.toggle_active
      flash[:success] = "#{@item.name} is now available for sale"
      redirect_to merchant_items_path
    else 
      @item.update(item_params)
      if @item.save
        redirect_to "/items/#{@item.id}"
      else
        flash[:error] = @item.errors.full_messages.to_sentence
        render :edit
      end
    end
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    redirect_to "/items"
  end

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end


end
