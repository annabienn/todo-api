require "test_helper"

class TodoItemsTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "i@i.com", password: "secret123", password_confirmation: "secret123")
    @todo = @user.todos.create!(title: "List")
  end

  test "create todo item" do
    post "/todos/#{@todo.id}/items",
         params: { todo_item: { name: "Item A" } }.to_json,
         headers: auth_headers(@user.auth_token)

    assert_response :created
    assert_equal "Item A", JSON.parse(response.body)["name"]
  end

  test "show todo item" do
    item = @todo.todo_items.create!(name: "Item B")

    get "/todos/#{@todo.id}/items/#{item.id}", headers: auth_headers(@user.auth_token)

    assert_response :ok
    assert_equal "Item B", JSON.parse(response.body)["name"]
  end

  test "update todo item" do
    item = @todo.todo_items.create!(name: "Item C")

    put "/todos/#{@todo.id}/items/#{item.id}",
        params: { todo_item: { name: "Item C2", done: true } }.to_json,
        headers: auth_headers(@user.auth_token)

    assert_response :ok
    assert_equal "Item C2", JSON.parse(response.body)["name"]
    assert_equal true, JSON.parse(response.body)["done"]
  end

  test "delete todo item" do
    item = @todo.todo_items.create!(name: "Item D")

    delete "/todos/#{@todo.id}/items/#{item.id}", headers: auth_headers(@user.auth_token)

    assert_response :ok
    assert_nil TodoItem.find_by(id: item.id)
  end
end
