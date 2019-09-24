class CreatePostrws < ActiveRecord::Migration[4.2]
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