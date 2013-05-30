class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :list_item_id

      t.timestamps
    end
  end
end
