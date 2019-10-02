migration_class =
  if ActiveRecord::VERSION::MAJOR >= 5
    ActiveRecord::Migration[4.2]
  else
    ActiveRecord::Migration
  end

class CreateLogOtherArchive < migration_class
  def up
    set_connection do
      create_table :log_others_archive do |t|
        t.references :post
        t.string :note
      end
    end
  end

  def down
    set_connection do
      drop_table :log_others_archive
    end
  end

  def set_connection
    connection_was = @connection
    @connection = ActiveRecord::Base.establish_connection(:"other_#{Rails.env}").connection
    yield
  ensure
    @connection = connection_was
    ActiveRecord::Base.remove_connection
    ActiveRecord::Base.establish_connection
  end
end
