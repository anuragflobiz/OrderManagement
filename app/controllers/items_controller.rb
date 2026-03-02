class ItemsController < ApplicationController
  before_action :set_item, only: [:update, :destroy]
  before_action :authorize_owner!, only: [:update, :destroy]
  before_action :authorize_retailer!, only: [:create]
  before_action :item_service

  def index
    result = @item_service.list(params)
    render_success(result)
  end

  def create
    item = @item_service.create(item_params)
    render_success(
      item.slice(:id, :name, :price, :quantity),
      "Item created",
      :created
    )
  end

  def update
    item = @item_service.update(@item, item_params)
    render_success(
      item.slice(:id, :name, :price, :quantity),
      "Item updated"
    )
  end

  def destroy
    @item_service.destroy(@item)
    render_success(nil, "Item deleted")
  end

  private

  def item_service
    @item_service ||= ItemService.new(current_user)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.permit(:name, :price, :quantity)
  end
  
  def authorize_owner!
    raise CustomErrors::Forbidden, "Access denied" unless @item.user_id == current_user.id
  end

  def authorize_retailer!
    raise CustomErrors::Forbidden, "Retailers only" unless @current_user.retailer?
  end
  
end