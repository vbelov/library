class AddBooksWritterToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :books_written, :integer
  end
end
