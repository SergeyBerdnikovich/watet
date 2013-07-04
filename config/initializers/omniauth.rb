Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :facebook, '307946899338802', 'fcc14b76bdf41b84a808965221f86d75'
  provider :facebook, '394395114009962', 'eb24e88ffb2fc60952d293dd30205982', #localhost:3000
  {
   :scope => "email",
   :secure_image_url => true,
   :image_size => :large,
   :display => 'popup',
   :provider_ignores_state => true
  }
  provider :google_oauth2, '127127904403-qi1ted9kql4vtj04u9149lki8t841up4.apps.googleusercontent.com', 'vEOmAOmfURqzpBsKd4aKEE1A', #localhost:3000
  #provider :google_oauth2, '437662557322-itghbd3ciicb4tal8c9djtu9aqf0lnpt.apps.googleusercontent.com', 'nh2oTryc3-oMNtbH85cReNkq', #https://watet.dvporg.com
  {
   :scope => "userinfo.email,userinfo.profile,plus.login",
   :approval_prompt => "force",
   :access_type => 'offline',
   :provider_ignores_state => true,
   :issuer => "437662557322-itghbd3ciicb4tal8c9djtu9aqf0lnpt@developer.gserviceaccount.com"

  }

end



OmniAuth.config.on_failure = Proc.new do |env|
  "ApplicationController".constantize.action(:omniauth_failure).call(env)
  #this will invoke the omniauth_failure action in UsersController.
end