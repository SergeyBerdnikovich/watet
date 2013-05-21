class ListItemsController < ApplicationController
  # GET /list_items
  # GET /list_items.json
  before_filter :check_user, :except => [:show, :index]

  def check_user
    redirect_to pages_welcome_path() unless user_signed_in?
  end

  def index
    
     if current_user && session[:soc_token].presence
      begin
      fb_user = FbGraph::User.me(session[:soc_token]).fetch
      @friends = fb_user.friends
      rescue
      end
    end

  if user_signed_in?
   @list_items = ListItem.where("user_id = ?", current_user.id)
   @list_item = ListItem.new
  else
      redirect_to pages_welcome_path()  and return false unless params[:id]
      @list_items = ListItem.where("user_id = ?", params[:id])

  end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @list_items }
    end
  end

  # GET /list_items/1
  # GET /list_items/1.json
  def show
    @list_item = ListItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @list_item }
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
    @list_item = ListItem.new(params[:list_item])
    @list_item.user_id = current_user.id

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
end
