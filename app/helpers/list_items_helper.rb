module ListItemsHelper
  def list_name
    if params[:uid] && params[:provider]
      params[:uid]
    else
      session[:soc_name]
    end
  end
end
