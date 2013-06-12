class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :name
      t.string :alt
	  t.attachment :image
      t.timestamps
    end
  end
end
