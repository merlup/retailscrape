Rails.application.routes.draw do

  namespace :api,  path: '/', constraints: { subdomain: 'api.retailscrape' } do
    root 'products#app_api' 
    get '/' => 'products#app_api'
    get "get_products" => "products#get_products"
    get 'app_api' => "products#app_api"
    get 'users/:id' => "users#show"
    get 'destroy_all' => 'products#destroy_all'
    jsonapi_resources :products
    jsonapi_resources :users
  end
 

  root 'navigation#home'
  get 'collections' => 'collections#index'
  get 'product_apis' => 'product_api#index'
  get 'destroy_all' => 'products#destroy_all'
  get 'app_api' => 'products#app_api'
  get "get_products" => "products#get_products"
  get "add_to_collection" => "collections#add_to_collection"
  get 'log_out' => "sessions#destroy"
  post 'log_in' =>  'sessions#create'
  get 'log_in' => 'sessions#new'
  post "users/:id" => "users#destroy"
  delete "products" => "products#destroy"
  delete "line_items/:id" => "collections#destroy_line_item"


  resources :products
  resources :collections
  resources :line_items
  resources :dashboard
  resources :users
 

  


end
