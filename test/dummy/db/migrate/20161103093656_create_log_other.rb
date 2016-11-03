class CreateLogOther < ActiveRecord::Migration
  def change
    create_table :log_others do |t|
      t.references :post
      t.string :note
    end
  end
end
