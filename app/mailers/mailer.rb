class Mailer < ActionMailer::Base
  default :from => "dev.dvporg@gmail.com"

  def send_list_items_link(user, email, session)
    @link = "http://watet.dvporg.com/list_items?provider=#{session[:soc_provider]}&uid=#{session[:soc_uid]}"
    @user = user
    @to_email = email
    mail(:to => @to_email, :subject => "list items from #{@user.email}")
  end
end