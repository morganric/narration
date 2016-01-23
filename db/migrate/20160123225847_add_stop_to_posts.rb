class AddStopToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :stop_time, :integer
  end
end
