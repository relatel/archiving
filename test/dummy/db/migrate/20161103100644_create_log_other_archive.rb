class OtherConnection < ActiveRecord::Base
  self.abstract_class = true

  establish_connection :"other_#{Rails.env}"
end

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
    @connection = OtherConnection.connection
    yield
  ensure
    @connection = connection_was
    OtherConnection.remove_connection
  end
end
