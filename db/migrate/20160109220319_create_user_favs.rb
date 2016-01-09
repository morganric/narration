class CreateUserFavs < ActiveRecord::Migration
  def change
    create_table :user_favs do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps null: false
    end
    add_index :user_favs, [:user_id, :post_id], unique: true
  end
end
