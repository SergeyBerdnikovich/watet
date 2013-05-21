class CreateListItems < ActiveRecord::Migration
  def change
    create_table :list_items do |t|
      t.string :title
      t.text :description
      t.string :geloc
      t.integer :priority

      t.timestamps
    end
  end
end
