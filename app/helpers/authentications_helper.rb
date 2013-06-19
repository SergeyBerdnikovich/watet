module AuthenticationsHelper
  def has_not_account?(provider)
    current_user ? Authentication.where("user_id = ? and provider = ?", current_user.id, provider).blank? : true
  end
end
