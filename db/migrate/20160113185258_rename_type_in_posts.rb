class RenameTypeInPosts < ActiveRecord::Migration
  def change
  	rename_column :posts, :type, :type_of
  end
end
