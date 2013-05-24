ActiveAdmin.register StaticPage do
  form do |f|
    f.inputs do
      f.input :name
      f.input :title
      f.input :content, :as => :ckeditor
    end
    f.buttons
  end

  show do
    attributes_table do
      row :id
      row :name
      row :title
      row :created_at
      row :updated_at
      row (:content) { |static_page| raw(static_page.content) }
    end
    active_admin_comments
  end
end
