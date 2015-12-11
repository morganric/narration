class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :url
      t.string :audio
      t.string :audio_link
      t.text :summary
      t.string :image
      t.integer :user_id
      t.string :slug
      t.integer :plays
      t.string :banner
      t.string :tag_list
      t.boolean :hidden
      t.boolean :featured
      t.text :html
      t.text :body

      t.timestamps null: false
    end
  end
end
