class PostsTag < ActiveRecord::Migration
  def change
    add_column :posts, :tag, :string
    add_column :posts_archive, :tag, :string
  end
end
