class CreatePostableOnLogDay < ActiveRecord::Migration
  def change
    %w(log_days log_days_archive).each do |table|
      add_column table, :postable_type, :string
      add_column table, :postable_id, :integer
    end
  end
end
