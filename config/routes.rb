Tet::Application.routes.draw do

  resources :list_items


  resources :static_pages


  match '/auth/:provider/callback' => 'authentications#create'

  resources :authentications

  root :to => 'list_items#index'
  get "pages/welcome"

  devise_for :users
end
