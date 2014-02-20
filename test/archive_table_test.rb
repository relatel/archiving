require 'test_helper'
 
class ArchiveTableTest < ActiveSupport::TestCase
  def setup
    Post.delete_all
    Post::Archive.delete_all
  end

  def test_creates_archive_model
    assert Post::Archive < Post
  end

  def test_shorthand_for_archive_model
    assert_equal Post::Archive, Post.archive
  end

  def test_add_archive_suffix_to_table_name
    assert_equal "posts_archive", Post::Archive.table_name
  end

  def test_with_archive_unions_results_from_both_tables
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
