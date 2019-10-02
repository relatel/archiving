migration_class =
  if ActiveRecord::VERSION::MAJOR >= 5
    ActiveRecord::Migration[4.2]
  else
    ActiveRecord::Migration
  end

class CreatePostableOnLogDay < migration_class
  def change
    %w(log_days log_days_archive).each do |table|
      add_column table, :postable_type, :string
      add_column table, :postable_id, :integer
    end
  end
end
