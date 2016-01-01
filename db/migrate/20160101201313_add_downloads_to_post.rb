class AddDownloadsToPost < ActiveRecord::Migration
  def change
    add_column :posts, :downloads, :integer, default: 0
  end
end
