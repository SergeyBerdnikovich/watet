class ListItemsController < ApplicationController
  # GET /list_items
  # GET /list_items.json
  before_filter :check_user, :only => [:edit, :update, :destroy]
  before_filter :check_current_user, :only => [:new, :create, :send_email_with_list_items_link]

  def index
    if user_signed_in?
      authentication = current_user.authentications.where(:provider => 'facebook')
      @friends = get_friends_for_(current_user)
      @list_items = ListItem.where("user_id = ?", current_user.id).order("list_items.created_at DESC")
      @list_item = ListItem.new
      @friends = get_friends_for_(current_user)
      @friends ||= []
    else
      redirect_to pages_welcome_path
    end
  end

  # GET /list_items/1
  # GET /list_items/1.json
  def show
    @user = User.find(params[:id])
    redirect_to root_path and return false if @user == current_user

    if @user
      @user.list_items.blank? ? @list_items = [] : @list_items = @user.list_items.order("list_items.created_at DESC")
      @friends = get_friends_for_(current_user) if user_signed_in?
      @friends ||= []
    else
      redirect_to root_path, :notice => 'User not found...'
    end
  end

  # GET /list_items/new
  # GET /list_items/new.json
  def new
    @list_item = ListItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @list_item }
    end
  end

  # GET /list_items/1/edit
  def edit
    @list_item = ListItem.find(params[:id])
  end

  # POST /list_items
  # POST /list_items.json
  def create
    @list_item = current_user.list_items.build(params[:list_item])

    respond_to do |format|
      if @list_item.save
        format.html { redirect_to list_items_url, notice: 'List item was successfully created.' }
        format.json { render json: @list_item, status: :created, location: @list_item }
      else
        format.html { render action: "new" }
        format.json { render json: @list_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /list_items/1
  # PUT /list_items/1.json
  def update
    @list_item = ListItem.find(params[:id])

    respond_to do |format|
      if @list_item.update_attributes(params[:list_item])
        format.html { redirect_to list_items_url, notice: 'List item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @list_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /list_items/1
  # DELETE /list_items/1.json
  def destroy
    @list_item = ListItem.find(params[:id])
    @list_item.destroy

    respond_to do |format|
      format.html { redirect_to list_items_url }
      format.json { head :no_content }
    end
  end

  def send_email_with_list_items_link
    Mailer.send_list_items_link(current_user, params[:email]).deliver unless params[:email].blank?
    redirect_to root_path, :notice => 'list items has been sent...'
  end

  private

  def get_friends_for_(current_user)
    friends = []
    current_user.authentications.each do |authentication|
      authentication.friends.each do |friend|
        friends << friend
      end
    end
    friends
  end

  def check_user
    list_item = ListItem.find(params[:id])
    unless user_signed_in? && list_item.user.id == current_user.id
      redirect_to pages_welcome_path
    end
  end

  def check_current_user
    redirect_to pages_welcome_path unless user_signed_in?
  end
end
