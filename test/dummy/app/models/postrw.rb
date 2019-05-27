class Postrw < ActiveRecord::Base
  has_archive_table read_only: false
end
