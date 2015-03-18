class Post < ActiveRecord::Base
  attr_accessible :title, :body, :tag

  has_archive_table
end
