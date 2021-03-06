Rails.application.routes.draw do

  namespace :api,  path: '/', constraints: { subdomain: 'api.retailscrape' } do
    root 'products#app_api' 
    get '/' => 'products#app_api'
    get "get_products" => "products#get_products"
    get 'app_api' => "products#app_api"
    get 'users/:id' => "users#show"
    get 'destroy_all' => 'products#destroy_all'
    post 'log_in' =>  'sessions#create'
    get 'log_in' => 'sessions#create'
    jsonapi_resources :products
    jsonapi_resources :users, except: :create
    resources :sessions

  end
 

  root 'navigation#home'
  get 'home' => 'navigation#home'
  get 'collections' => 'collections#index'
  get 'product_apis' => 'product_api#index'
  get 'destroy_all' => 'products#destroy_all'
  get 'app_api' => 'products#app_api'
  get "get_products" => "products#get_products"
  post "get_products" => "products#get_products"
  get "add_to_collection" => "collections#add_to_collection"
  get 'logout' => "sessions#destroy"
  delete 'logout' => "sessions#destroy"
  post 'log_in' =>  'sessions#create'
  get 'log_in' => 'sessions#new'
  post "users/:id" => "users#destroy"
  delete "products" => "products#destroy"
  delete "collections" => 'collections#destroy'
  delete "line_items/:id" => "collections#destroy_line_item"
  post 'collections' => 'collections#create'
  post "add_to_collection" => "collections#add_to_collection"

  resources :products
  resources :sessions
  resources :collections
  resources :line_items
  resources :dashboard
  resources :users
  resources :api_keys
 

  


end
