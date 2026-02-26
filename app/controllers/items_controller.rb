class ItemsController < ApplicationController
  before_action :set_item, only: [:update, :destroy]

  rescue_from ItemService::UnauthorizedError, with: :forbidden

  def index
    result = ItemService.list(current_user, params)
    render_success(result)
  end


  def create
    item = ItemService.create(current_user, item_params)
    render_success(item.slice(:id, :name, :price, :quantity), "Item created", :created)
  end

  def update
    item = ItemService.update(current_user, @item, item_params)
    render_success(item.slice(:id, :name, :price, :quantity), "Item updated")
  end

  def destroy
    ItemService.destroy(current_user, @item)
    render_success(nil, "Item deleted")
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def forbidden(exception)
    render_forbidden(exception.message)
  end

  def item_params
    params.permit(:name, :price, :quantity)
  end
end