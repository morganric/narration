class AddEmbedsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :embeds, :integer, default: 0
  end
end
