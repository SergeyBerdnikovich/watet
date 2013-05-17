Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '394395114009962', 'eb24e88ffb2fc60952d293dd30205982'
  provider :google, '127127904403.apps.googleusercontent.com', 'asg9jywPGgi_9ZKSNxBbDve7' #https://watet.dvporg.com
  #provider :google, '127127904403-qi1ted9kql4vtj04u9149lki8t841up4.apps.googleusercontent.com', 'vEOmAOmfURqzpBsKd4aKEE1A' #localhost:3000
end