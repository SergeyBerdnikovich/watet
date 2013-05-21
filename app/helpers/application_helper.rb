module ApplicationHelper
  def get_avatar
    session[:soc_ava].blank? ? image_tag('/assets/maket/no_avatar.png') : image_tag(session[:soc_ava])
  end
end
