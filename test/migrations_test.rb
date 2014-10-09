require 'test_helper'

class Comment < ActiveRecord::Base
  has_archive_table
end

class CreateComments < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.string :author
      t.text :body
    end

    create_archive_table :comments
  end
end

class MigrationTest < ActiveSupport::TestCase
  def connection
    ActiveRecord::Base.connection
  end

  def drop_tables
    connection.drop_table(:comments) if connection.table_exists?(:comments)
    connection.drop_table(:comments_archive) if connection.table_exists?(:comments_archive)
  end

  setup do
    drop_tables
  end

  teardown do
    drop_tables
  end

  test "create_archive_table" do
    CreateComments.new.up

    assert connection.table_exists?(:comments_archive),
      "Expected table 'comments_archive' to exist."

    assert_equal Comment.attribute_names, Comment.archive.attribute_names
  end

  test "ignore existing archive table" do
    CreateComments.new.up
    CreateComments.new.create_archive_table :comments # we can re-run archive table creator without errors
  end

end
