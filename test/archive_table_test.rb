require 'test_helper'

class ArchiveTableTest < ActiveSupport::TestCase
  setup do
    Post.delete_all
    Post::Archive.delete_all
  end

  test "creates_archive_model" do
    assert Post::Archive < Post
  end

  test "shorthand for archive model" do
    assert_equal Post::Archive, Post.archive
  end

  test "add archive suffix to table name" do
    assert_equal "posts_archive", Post::Archive.table_name
  end

  test "with_archive unions results from both tables" do
    p1 = Post.create!(title: "Post 1", tag: "news")
    p2 = Post.create!(title: "Post 2", tag: "misc")
    a1 = Post::Archive.create!(title: "Archive 1", tag: "news")
    a2 = Post::Archive.create!(title: "Archive 2", tag: "misc")

    set = Post.with_archive(lambda {|scoped|
      scoped.where(tag: "misc")
    })

    assert_equal [p2, a2].sort, set.sort
  end
end
