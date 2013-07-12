class ListItemsController < ApplicationController
  # GET /list_items
  # GET /list_items.json
  before_filter :check_user, :only => [:edit, :update, :destroy]
  before_filter :check_current_user, :only => [:new, :create, :send_email_with_list_items_link]

  def index
    if user_signed_in?
      redirect_to user_url(current_user)
    else
      redirect_to pages_welcome_path
    end
  end

  def sort
    logger = Logger.new("sort_log.txt")
    logger.info params
    order = params[:order]
    i = 0
    order.each{|id|
      id = id.to_i #some more protection
      sql = "UPDATE list_items SET priority = #{i} WHERE id = #{id} AND user_id = #{current_user.id}"
      ActiveRecord::Base.connection.execute sql
      i += 1
    }

    render :nothing => true, :status => 200
  end

  # GET /list_items/1/edit
  def image_form
    @list_item = ListItem.find(params[:list_item_id])
    @list_item.images.build
    render :layout => 'empty'
  end

  def edit
    @list_item = ListItem.find(params[:id])
    @list_item.images.build
  end

  # POST /list_items
  # POST /list_items.json
  def create
    redirect_to user_path(current_user), :notice => t('list_items.title_blank') and return nil if params[:list_item][:title].blank?
    images_arr = params[:images]
    params[:list_item].delete(:image)
    @list_item = current_user.list_items.build(params[:list_item])

    #setting up the highiest priority to new list item appears at the top
    biggest_priority = current_user.list_items.where('priority IS NOT NULL').limit(1).order('priority ASC').first
    if biggest_priority
      biggest_priority = biggest_priority.priority
    else
      biggest_priority = 0
    end

    @list_item.priority = biggest_priority - 1
    @image = Image.new(images_arr)
    @list_item.images << @image

    respond_to do |format|
      if @list_item.save
        format.html { session[:open_edit] = @list_item.id #to open new list item in edit mode in fronend after creation
                               redirect_to user_url(current_user) }
        format.json { render json: @list_item, status: :created, location: @list_item }
      else
        format.html { render action: "new" }
        format.json { render json: @list_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_images
    images_arr = params[:images]
    @list_item = ListItem.find(params[:list_item_id])
    @image = Image.new(images_arr)
    @list_item.images << @image

    respond_to do |format|
      format.html { redirect_to list_item_image_form_url }
      format.json { render :json => @list_item }
    end
  end

  def delete_image
    @list_item = ListItem.find(params[:list_item_id])
    image = @list_item.images.where('id = ?',params[:image_id]).first
    image.image.destroy #Will remove the attachment and save the model
    image.image.clear
    image.destroy
    respond_to do |format|
      format.html { redirect_to list_item_image_form_url }
      format.json { render :json => @list_item }
    end
  end

  # PUT /list_items/1
  # PUT /list_items/1.json
  def update
    images_arr = params[:images]
    params[:list_item].delete(:image)
    @list_item = ListItem.find(params[:id])
    @image = Image.new(images_arr)
    @list_item.images << @image

    respond_to do |format|
      if @list_item.update_attributes(params[:list_item])
        format.html { redirect_to user_url(current_user), notice: t('list_items.updated') }
        format.json { render :json => @list_item }
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
      format.html { render :nothing => true}
      format.json { head :no_content }
    end
  end

  def send_email_with_list_items_link
    redirect_to user_path(current_user), :notice => t('list_items.email_blank') and return nil if params[:email].blank?
    unless params[:email].blank?
      emails = params[:email].scan(/[a-z0-9!\x23$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!\x23$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/)
      sent_list = ""
      emails.each do |email|
        if sent_list.match(/;#{email};/miu) == nil
          Mailer.delay.send_list_items_link(current_user, email)
          sent_list += ";#{email};"
        end
      end
      redirect_to root_path, :notice => t('list_items.sended')
    end
  end

  private

  def check_user
    list_item = ListItem.find(params[:id])
    unless user_signed_in? && list_item.user.id == current_user.id
      redirect_to pages_welcome_path
    end
  end
end
