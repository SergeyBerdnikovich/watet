class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :fname
      t.string :lname
      t.string :city
      t.string :state
      t.integer :zip
      t.string :phone
      t.string :avatar
      t.integer :user_id
      t.boolean :agreed
      t.string :site_link

      t.timestamps
    end
  end
end
