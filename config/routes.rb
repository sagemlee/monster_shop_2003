Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/admin", to: "admins#show"

  namespace :admin do
    get '/merchants/:merchant_id', to: "merchants#show"
    get '/merchants', to: "merchants#index"
    get "/merchants/status/:id", to: "merchants#update"
    
    get '/users', to: 'users#index'
    get '/profile/:user_id', to: 'users#show'

    patch '/orders/:order_id', to: 'orders#update'
    get "/users/:user_id/orders/:order_id", to: "orders#show"
  end

  get "/merchant", to: "merchant#show"

  namespace :merchant do
    get '/orders/:order_id', to: 'orders#show'
    patch '/orders/:order_id', to: 'orders#update'

    get '/items', to: 'items#index'
    get '/items/:id/status', to: 'items#status'
    get '/items/:id/edit', to: 'items#edit'
    patch '/items/:id', to: 'items#update'
    get '/items/new', to: 'items#new'
    post '/items', to: 'items#create'
    delete '/items/:id', to: 'items#destroy'
  end

  resources :merchants
  # get "/merchants", to: "merchants#index"
  # get "/merchants/new", to: "merchants#new"
  # get "/merchants/:id", to: "merchants#show"
  # post "/merchants", to: "merchants#create"
  # get "/merchants/:id/edit", to: "merchants#edit"
  # patch "/merchants/:id", to: "merchants#update"
  # delete "/merchants/:id", to: "merchants#destroy"

  resources :items, except: [:new, :create]
  # get "/items", to: "items#index"
  # get "/items/:id", to: "items#show"
  # get "/items/:id/edit", to: "items#edit"
  # patch "/items/:id", to: "items#update"
  # delete "/items/:id", to: "items#destroy"
  
  namespace :cart do
    post "/:item_id", to: "items#new"
    delete "/:item_id", to: "items#destroy"
    patch "/:item_id", to: "items#update"
  end

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"
 
  get "/merchants/:merchant_id/items", to: "merchants_items#index"
  get "/merchants/:merchant_id/items/new", to: "merchants_items#new"
  post "/merchants/:merchant_id/items", to: "merchants_items#create"
  
  resources :reviews, only: [:edit, :update, :destroy]
  # get "/reviews/:id/edit", to: "reviews#edit"
  # patch "/reviews/:id", to: "reviews#update"
  # delete "/reviews/:id", to: "reviews#destroy"

  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#destroy"

  resources :users, only: [:create]
  #post "/users", to: "users#create"

  get "/profile", to: "users#show"
  get "/profile/edit", to: "users#edit"
  post "/profile", to: "users#update"
  get "/register", to: "users#new"

  #resources :password, only: [:edit, :update]
  get "/password/edit", to: "password#edit"
  post "/password", to: "password#update"

  resources :orders, except: [:destroy]
  # get "/orders/new", to: "orders#new"
  # post "/orders", to: "orders#create"
  # get "/profile/orders/:id", to: "orders#show"
  # get "/profile/orders", to: "orders#index"
  # patch "/profile/orders/:id", to: "orders#update"

  get "error404", to: "errors#show"
end
