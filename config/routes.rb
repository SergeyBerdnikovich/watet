Tet::Application.routes.draw do

  match '/auth/:provider/callback' => 'authentications#create'

  resources :authentications, :only => [:index]

  root :to => 'pages#welcome'
  #get "pages/welcome"

  devise_for :users, :skip => [:sessions, :passwords, :registrations] do
    get "/users/sign_out" => "devise/sessions#destroy", :as => :destroy_user_session
  end
end
