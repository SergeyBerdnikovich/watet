Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '394395114009962', 'eb24e88ffb2fc60952d293dd30205982'
  provider :google, '127127904403.apps.googleusercontent.com', 'asg9jywPGgi_9ZKSNxBbDve7'
end