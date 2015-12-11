class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :display_name
      t.string :image
      t.string :banner
      t.string :slug
      t.text :bio
      t.string :website
      t.string :twitter

      t.timestamps null: false
    end
    add_index :profiles, :slug, unique: true
  end
end
