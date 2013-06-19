class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def delete
     respond_to do |format|
      format.html { }
    end
  end

   def destroy
    @user = User.find(params[:id])
    @user.destroy if current_user = @user

    respond_to do |format|
      format.html { redirect_to root_path}
      format.json { head :no_content }
    end
  end


    def sign_out
      session.destroy
    end

  def show
    if current_user.sign_in_count == 1
      flash[:notice] = 'Please, remember that all your facebook and/or google friends will see your whole list!'
      flash[:notice2] = 'To add your google/facebook friends go to settings and login with another account.'
      current_user.update_attribute(:sign_in_count, 2)
    end

     redirect_to root_path and return false if params[:id] == 'sign_out'
    @user = User.where('slug = ?',params[:id])
    redirect_to root_path and return false if @user == nil
    @user = @user.first
    @friends = get_friends_for_(@user)
      @list_items = ListItem.where("user_id = ?", @user.id).order("list_items.priority ASC")
      if @user == current_user
      @new_list_item = ListItem.new
      @new_list_item.images.build
      end
      @friends = get_friends_for_(@user)
      @friends ||= []


    respond_to do |format|
      format.html {render :template => "list_items/index"}
      format.json { render json: @user }
    end
  end


end
