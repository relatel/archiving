migration_class =
  if ActiveRecord::VERSION::MAJOR >= 5
    ActiveRecord::Migration[4.2]
  else
    ActiveRecord::Migration
  end

class PostsTag < migration_class
  def change
    add_column :posts, :tag, :string
    add_column :posts_archive, :tag, :string
  end
end
