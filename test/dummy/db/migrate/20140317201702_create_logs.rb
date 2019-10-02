migration_class =
  if ActiveRecord::VERSION::MAJOR >= 5
    ActiveRecord::Migration[4.2]
  else
    ActiveRecord::Migration
  end

class CreateLogs < migration_class
  def change
    create_table :log_days do |t|
      t.references :post
      t.date :day
    end
    create_table :log_days_archive do |t|
      t.references :post
      t.date :day
    end

    create_table :log_lines do |t|
      t.references :log_day
      t.string :descr
    end
    create_table :log_lines_archive do |t|
      t.references :log_day
      t.string :descr
    end
  end

end
