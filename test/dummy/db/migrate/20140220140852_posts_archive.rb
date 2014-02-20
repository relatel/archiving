class PostsArchive < ActiveRecord::Migration
  def change
    create_table :posts_archive do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
