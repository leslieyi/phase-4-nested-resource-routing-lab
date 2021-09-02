class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  # show all, User has many items
  def index
    if params[:user_id]
      user = find_user
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  # one item!find that one item nested in users
  def show
    item = find_item
    render json: item
  end

  def create #create an item that belongs to a user, so you need to find the user first
    user = find_user
    item = user.items.create(item_params)
    render json: item,  status: :created 
  end

  private

  def find_user
    User.find(params[:user_id])
  end

  def find_item
    Item.find(params[:id])
  end

  def item_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_response(exception)
    render json: { error: "#{exception.model} not found" },
           status: :not_found
  end
end
