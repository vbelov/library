class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :name, null: false, index: true
      t.integer :year, null: false
    end
  end
end
