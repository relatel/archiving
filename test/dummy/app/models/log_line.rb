class LogLine < ActiveRecord::Base
  attr_accessible :descr
  has_many :log_day

  has_archive_table
end

