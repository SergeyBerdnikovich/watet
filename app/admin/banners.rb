ActiveAdmin.register Banner do
  form :html => { :enctype => "multipart/form-data" } do |f|
   f.inputs "Details" do
    f.input :name
    f.input :alt
    f.input :url
    f.input :image, :as => :file, :hint => f.template.image_tag(f.object.image.url(:medium))
  end
  f.buttons
 end
end
