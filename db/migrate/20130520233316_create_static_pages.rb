class CreateStaticPages < ActiveRecord::Migration
  def change
    create_table :static_pages do |t|
      t.string :name
      t.string :title
      t.text :content
      t.string :locale

      t.timestamps
    end
  end
end
