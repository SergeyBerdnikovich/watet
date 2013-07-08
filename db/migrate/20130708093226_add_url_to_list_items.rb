class AddUrlToListItems < ActiveRecord::Migration
  def change
    add_column :list_items, :url, :string
  end
end
