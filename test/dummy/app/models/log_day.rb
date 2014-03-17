class LogDay < ActiveRecord::Base
  attr_accessible :day, :post
  belongs_to :post
  has_many :log_lines

  has_archive_table
  has_archive_associations [:post, :log_lines]
end
