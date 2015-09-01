class AddFirstLetterToBooks < ActiveRecord::Migration
  def change
    add_column :books, :first_letter, :string, limit: 1, index: true
  end
end
