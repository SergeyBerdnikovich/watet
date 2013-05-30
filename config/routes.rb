Tet::Application.routes.draw do



  root :to => 'list_items#index'

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  match 'list_items/send_email_with_list_items_link' => 'list_items#send_email_with_list_items_link', :as => :send_list_items
  match 'list_items/sort' => 'list_items#sort'#, :via => :post

  resources :list_items do

    resources :images
  end

  

  match '/static_pages/license' => 'static_pages#license', :as => :license
  resources :static_pages

  resources :profiles, :only => [:show, :edit, :update]

  match '/auth/:provider/callback' => 'authentications#create'

  resources :authentications#, :only => [:index]

  get "pages/welcome"

  devise_for :users, :skip => [:sessions, :passwords, :registrations] do
    ActiveAdmin.routes(self)
    get "/users/sign_out" => "devise/sessions#destroy", :as => :destroy_user_session
  end
end
