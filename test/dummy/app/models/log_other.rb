class LogOther < ActiveRecord::Base
  belongs_to :post

  has_archive_table connection: :"other_#{Rails.env}"
  has_archive_associations [:post]
end

