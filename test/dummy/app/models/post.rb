class Post < ActiveRecord::Base
  attr_accessible :body, :title

  has_archive_table
end
