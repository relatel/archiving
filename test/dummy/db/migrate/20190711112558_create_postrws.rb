migration_class =
  if ActiveRecord::VERSION::MAJOR >= 5
    ActiveRecord::Migration[4.2]
  else
    ActiveRecord::Migration
  end

class CreatePostrws < migration_class
  def change
    create_table :postrws do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
    create_table :postrws_archive do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
