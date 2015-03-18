class LogLine < ActiveRecord::Base
  has_many :log_day

  has_archive_table
end

