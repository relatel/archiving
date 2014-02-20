require 'test_helper'
 
class ArchiveTableTest < Test::Unit::TestCase
  def test_archive_table_creates_archive_model
    assert Post::Archive < Post
  end

  def test_add_archive_suffix_to_table_name
    assert_equal "posts_archive", Post::Archive.table_name
  end
end
