Rails.application.routes.draw do
  post "/signup", to: "users#create"
  post "/auth/login", to: "auth#login"
  get "/auth/logout", to: "auth#logout"

  resources :todos, only: [:index, :show, :create, :update, :destroy] do
    resources :items, controller: "todo_items", only: [:show, :create, :update, :destroy]
  end
end
