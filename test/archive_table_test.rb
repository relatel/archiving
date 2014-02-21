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
    p1 = Post.create!
    a1 = Post::Archive.create!

    set = Post.with_archive

    assert_equal Set.new([p1, a1]), Set.new(set)
  end

  test "with_archive applies lambda to query" do
    p1 = Post.create!(title: "Post 1", tag: "news")
    p2 = Post.create!(title: "Post 2", tag: "misc")
    a1 = Post::Archive.create!(title: "Archive 1", tag: "news")
    a2 = Post::Archive.create!(title: "Archive 2", tag: "misc")

    set = Post.with_archive(lambda {|scoped|
      scoped.where(tag: "misc")
    })

    assert_equal Set.new([p2, a2]), Set.new(set)
  end

  test "with_archive takes :limit" do
    p1 = Post.create!
    p2 = Post.create!
    a1 = Post::Archive.create!
    a2 = Post::Archive.create!

    set = Post.with_archive(limit: 3)

    assert_equal 3, set.size
  end

  test "with_archive takes :offset" do
    p1 = Post.create!
    p2 = Post.create!
    a1 = Post::Archive.create!
    a2 = Post::Archive.create!

    set = Post.with_archive(limit: 10, offset: 2)

    assert_equal 2, set.size
  end

  test "with_archive takes :order" do
    p1 = Post.create!(tag: 3)
    p2 = Post.create!(tag: 4)
    a1 = Post::Archive.create!(tag: 1)
    a2 = Post::Archive.create!(tag: 2)

    set = Post.with_archive(order: "tag DESC")

    assert_equal [p2, p1, a2, a1], set
  end

  test "with_archive takes lambda and options" do
    p1 = Post.create!(title: "4", tag: "news")
    p2 = Post.create!(title: "3", tag: "misc")
    a1 = Post::Archive.create!(title: "2", tag: "misc")
    a2 = Post::Archive.create!(title: "1", tag: "misc")

    set = Post.with_archive(
      lambda {|scoped|
        scoped.where(tag: "misc")
      },
      limit: 2,
      order: "title ASC"
    )

    assert_equal [a2, a1], set
  end

  test "new archive records can be persisted" do
    assert_nothing_raised do
      Post::Archive.create!
    end
  end

  test "existing archive records are read only" do
    archive = Post::Archive.create!
    archive = Post::Archive.find(archive.id)

    assert_raises(ActiveRecord::ReadOnlyRecord) do
      archive.update_attribute(:title, "New post")
    end
  end

  test "existing archive records fetched with with_archive are read only" do
    Post::Archive.create!

    archive = Post.with_archive.first

    assert_raises(ActiveRecord::ReadOnlyRecord) do
      archive.title = "New post"
      archive.save!
    end
  end
end
