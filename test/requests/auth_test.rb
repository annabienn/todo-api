require "test_helper"

class AuthTest < ActionDispatch::IntegrationTest
  test "signup returns token" do
    post "/signup",
         params: { user: { email: "a@a.com", password: "secret123", password_confirmation: "secret123" } }.to_json,
         headers: json_headers

    assert_response :created
    assert JSON.parse(response.body)["token"].present?
  end

  test "login returns token" do
    user = User.create!(email: "b@b.com", password: "secret123", password_confirmation: "secret123")

    post "/auth/login",
         params: { email: user.email, password: "secret123" }.to_json,
         headers: json_headers

    assert_response :ok
    assert JSON.parse(response.body)["token"].present?
  end

  test "logout invalidates token" do
    user = User.create!(email: "c@c.com", password: "secret123", password_confirmation: "secret123")
    old_token = user.auth_token

    get "/auth/logout", headers: auth_headers(old_token)

    assert_response :ok
    assert_not_equal old_token, user.reload.auth_token
  end
end
