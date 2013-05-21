class AddUseridToListItems < ActiveRecord::Migration
  def change
    add_column :list_items, :user_id, :integer
  end
end
