class ChangePostPlays < ActiveRecord::Migration
  def change
  	change_column :posts, :plays, :integer, :default => 0
  end
end
