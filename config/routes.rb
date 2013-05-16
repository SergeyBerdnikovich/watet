Tet::Application.routes.draw do

  match '/auth/:provider/callback' => 'authentications#create'

  resources :authentications

  root :to => 'pages#welcome'
  get "pages/welcome"

  devise_for :users
end
