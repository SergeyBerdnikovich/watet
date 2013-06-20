Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :facebook, '307946899338802', 'fcc14b76bdf41b84a808965221f86d75'
  provider :facebook, '394395114009962', 'eb24e88ffb2fc60952d293dd30205982',
  {
   :scope => "email",
   :secure_image_url => true,
   :image_size => :large,
   :display => 'popup',
   :provider_ignores_state => true
  }
  #provider :google_oauth2, '127127904403.apps.googleusercontent.com', 'asg9jywPGgi_9ZKSNxBbDve7' #https://watet.dvporg.com
  #provider :google_oauth2, '127127904403-qi1ted9kql4vtj04u9149lki8t841up4.apps.googleusercontent.com', 'vEOmAOmfURqzpBsKd4aKEE1A', #localhost:3000
  provider :google_oauth2, '437662557322.apps.googleusercontent.com', 'K_08Su52-9udLLfKRq2Gk8mP', #https://watet.dvporg.com
  {
   :scope => "userinfo.email,userinfo.profile,plus.me",
   :approval_prompt => "auto",
   :provider_ignores_state => true
  }

end



OmniAuth.config.on_failure = Proc.new do |env|
  "ApplicationController".constantize.action(:omniauth_failure).call(env)
  #this will invoke the omniauth_failure action in UsersController.
end