Tet::Application.routes.draw do

  resources :list_items


  resources :static_pages


  match '/auth/:provider/callback' => 'authentications#create'

  resources :authentications, :only => [:index]

  root :to => 'list_items#index'
  get "pages/welcome"

  devise_for :users, :skip => [:sessions, :passwords, :registrations] do
    get "/users/sign_out" => "devise/sessions#destroy", :as => :destroy_user_session
  end
end
