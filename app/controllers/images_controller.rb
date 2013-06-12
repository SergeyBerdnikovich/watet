class ImagesController < InheritedResources::Base

 def show
    @image = Image.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.json { render json: @image }
    end
        
 end


end
