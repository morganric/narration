class AddEntToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :end_time, :integer, default: 0
  end
end
