class AddAuthorToPost < ActiveRecord::Migration
  def change
    add_column :posts, :author, :string
    add_column :posts, :author_url, :string
    add_column :posts, :provider, :string
    add_column :posts, :provider_url, :string
  end
end
