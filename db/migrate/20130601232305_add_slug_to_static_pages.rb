class AddSlugToStaticPages < ActiveRecord::Migration
  def change
    add_column :static_pages, :slug, :string
    add_index :static_pages, :slug, unique: true
  end
end
