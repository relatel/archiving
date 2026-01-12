class LogDay < ActiveRecord::Base
  belongs_to :post, optional: true
  belongs_to :postable, polymorphic: true, optional: true
  has_many :log_lines

  has_archive_table
  has_archive_associations [:post, :log_lines, :postable]
end
