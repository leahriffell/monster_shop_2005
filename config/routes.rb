Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "welcome#index", as: :root

  namespace :merchant do
    get "/", to: "dashboard#index", as: :dashboard
    get "/items", to: "items#index", as: :items
  end

  resources :merchants,  except: [:update]
  patch "/merchants/:id", to: "merchants#update", as: :merchant_update

  resources :items, only: [:index, :show, :edit, :destroy]

  patch "/items/:id", to: "items#update", as: :item_update
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  resources :reviews, only: [:edit, :update, :destroy]

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  patch "/cart/:item_id", to: "cart#increase_quantity"
  put "/cart/:item_id", to: "cart#decrease_quantity"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  resources :orders, only: [:new, :create, :update, :show]
  get "/orders/:id", to: "orders#show", as: :order_show

  resources :users, only: [:create]

  get "/register", to: "users#new"
  get "/profile", to: "users#show"
  get "profile/edit", to: "users#edit"
  patch "profile/edit", to: "users#update"
  get "/profile/orders", to: "users/orders#index", as: :profile_orders
  get "/profile/orders/:id", to: "orders#show"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  namespace :admin do
    get "/", to: "dashboard#index", as: :dashboard
    get "/merchants/:merchant_id", to: "dashboard#merchant", as: :dashboard_merchant
    get "/merchants/:merchant_id/items", to: "dashboard#merchant_items", as: :dashboard_merchant_items
  end

  scope :admin do
    get "/merchants", to: "merchants#index", as: :admin_merchants
  end

  resources :admin, only: [:index]
end
