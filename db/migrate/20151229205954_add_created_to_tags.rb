class AddCreatedToTags < ActiveRecord::Migration
  def change
    add_column :tags, :created_at, :date
  end
end
