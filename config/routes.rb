Tet::Application.routes.draw do

  match 'list_items/send_email_with_list_items_link' => 'list_items#send_email_with_list_items_link', :as => :send_list_items

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
