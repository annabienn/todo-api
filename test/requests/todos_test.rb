require "test_helper"

class TodosTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "u@u.com", password: "secret123", password_confirmation: "secret123")
  end

  test "list todos" do
    todo = @user.todos.create!(title: "One")
    todo.todo_items.create!(name: "Item 1")

    get "/todos", headers: auth_headers(@user.auth_token)

    assert_response :ok
    body = JSON.parse(response.body)
    assert_equal 1, body.length
    assert_equal "One", body.first["title"]
    assert_equal 1, body.first["todo_items"].length
  end

  test "create todo" do
    post "/todos",
         params: { todo: { title: "New Todo" } }.to_json,
         headers: auth_headers(@user.auth_token)

    assert_response :created
    assert_equal "New Todo", JSON.parse(response.body)["title"]
  end

  test "show todo" do
    todo = @user.todos.create!(title: "Show Me")

    get "/todos/#{todo.id}", headers: auth_headers(@user.auth_token)

    assert_response :ok
    assert_equal "Show Me", JSON.parse(response.body)["title"]
  end

  test "update todo" do
    todo = @user.todos.create!(title: "Old")

    put "/todos/#{todo.id}",
        params: { todo: { title: "Updated" } }.to_json,
        headers: auth_headers(@user.auth_token)

    assert_response :ok
    assert_equal "Updated", JSON.parse(response.body)["title"]
  end

  test "delete todo" do
    todo = @user.todos.create!(title: "Delete Me")
    todo.todo_items.create!(name: "Item")

    delete "/todos/#{todo.id}", headers: auth_headers(@user.auth_token)

    assert_response :ok
    assert_nil Todo.find_by(id: todo.id)
  end
end
