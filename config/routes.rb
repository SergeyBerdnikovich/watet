Tet::Application.routes.draw do

  scope "(:locale)", :locale => /en|ru|de|pl|cn|it|es/ do
    resources :banners

    root :to => 'list_items#index'

    mount Ckeditor::Engine => '/ckeditor'

    match 'list_items/send_email_with_list_items_link' => 'list_items#send_email_with_list_items_link', :as => :send_list_items
    match 'list_items/sort' => 'list_items#sort'#, :via => :post

    resources :list_items do
      get 'image_form'
      delete 'delete_image'
      put 'update_images'

      resources :images
    end

    match '/settings' => 'authentications#index', :as => :settings
    match '/static_pages/license' => 'static_pages#license', :as => :license
    resources :static_pages

    resources :profiles



    resources :authentications#, :only => [:index]

    get "pages/welcome"
    get "pages/application"

    devise_for :users, :skip => [:sessions, :passwords, :registrations] do
      ActiveAdmin.routes(self)
      get "/users/sign_out" => "devise/sessions#destroy", :as => :destroy_user_session
    end

    resources :users do
      get 'delete'
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

   match '/auth/:provider/callback' => 'authentications#create'
end
