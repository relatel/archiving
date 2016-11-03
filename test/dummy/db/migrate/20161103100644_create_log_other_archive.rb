class CreateLogOtherArchive < ActiveRecord::Migration
  def up
    set_connection
    create_table :log_others_archive do |t|
      t.references :post
      t.string :note
    end
    restore_connection
  end

  def down
    set_connection
    drop_table :log_others_archive
    restore_connection
  end

  def set_connection
    @connection_was = @connection
    @connection = ActiveRecord::Base.establish_connection(:"other_#{Rails.env}").connection
  end

  def restore_connection
    @connection = @connection_was
    ActiveRecord::Base.remove_connection
    ActiveRecord::Base.establish_connection
  end
end
