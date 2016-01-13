class AddStartToPost < ActiveRecord::Migration
  def change
    add_column :posts, :start_time, :integer, default: 0
    add_column :posts, :type, :string
  end
end
