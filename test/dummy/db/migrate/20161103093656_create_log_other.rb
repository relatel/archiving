migration_class =
  if ActiveRecord::VERSION::MAJOR >= 5
    ActiveRecord::Migration[4.2]
  else
    ActiveRecord::Migration
  end

class CreateLogOther < migration_class
  def change
    create_table :log_others do |t|
      t.references :post
      t.string :note
    end
  end
end
