class Mailer < ActionMailer::Base
  default :from => "dev.dvporg@gmail.com"

  def send_list_items_link(user, email)
    if user.slug.blank?
      @link = "http://watet.dvporg.com/users/#{user.id}"
    else
      @link = "http://watet.dvporg.com/users/#{user.slug}"
    end

    @user = user
    @to_email = email
    mail(:to => @to_email, :subject => "#{@user.profile.fname} #{@user.profile.lname} " + t(:share_email_subject) )
  end
end