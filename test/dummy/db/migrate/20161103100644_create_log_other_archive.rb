class CreateLogOtherArchive < ActiveRecord::Migration
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
    @connection = connection_was
    ActiveRecord::Base.remove_connection
    ActiveRecord::Base.establish_connection
  end
end
