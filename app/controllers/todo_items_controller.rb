class TodoItemsController < ApplicationController
  before_action :authenticate!
  before_action :set_todo
  before_action :set_item, only: [:show, :update, :destroy]

  def show
    render json: @item, status: :ok
  end

  def create
    item = @todo.todo_items.build(todo_item_params)

    if item.save
      render_created_item(item)
    else
      render_item_errors(item)
    end
  end

  def update
    if @item.update(todo_item_params)
      render json: @item, status: :ok
    else
      render_item_errors(@item)
    end
  end

  def destroy
    @item.destroy
    render json: { message: "Todo item deleted" }, status: :ok
  end

  private

  def set_todo
    @todo = current_user.todos.find(params[:todo_id])
  end

  def set_item
    @item = @todo.todo_items.find(params[:id])
  end

  def todo_item_params
    params.require(:todo_item).permit(:name, :done)
  end

  def render_created_item(item)
    render json: item, status: :created
  end

  def render_item_errors(item)
    render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
  end
end
