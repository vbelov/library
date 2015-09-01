class AddIndexOnYearToBooks < ActiveRecord::Migration
  def change
    add_index :books, :year
  end
end
