class LogDay < ActiveRecord::Base
  attr_accessible :day, :post, :postable, :postable_type, :postable_id
  belongs_to :post
  belongs_to :postable, polymorphic: true
  has_many :log_lines

  has_archive_table
  has_archive_associations [:post, :log_lines, :postable]
end
