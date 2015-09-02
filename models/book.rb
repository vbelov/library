class Book < ActiveRecord::Base
  has_and_belongs_to_many :authors

  MIN_YEAR = 1945
  MAX_YEAR = Time.now.year

  validates :name, presence: true
  validates :year, numericality: { only_integer: true,
                                   greater_than_or_equal_to: MIN_YEAR,
                                   less_than_or_equal_to: MAX_YEAR }

  before_save :set_first_letter

  def self.per_year_stats(most_productive_authors = nil)
    if most_productive_authors
      sql =  "SELECT year, count(*) FROM books WHERE id IN
          (
          SELECT book_id FROM authors_books WHERE author_id IN
          (SELECT id FROM authors ORDER BY books_written DESC LIMIT #{most_productive_authors})
          )
          GROUP BY year
          ORDER BY year;"
    else
      sql = 'SELECT year, count(*) AS count FROM books GROUP BY year ORDER BY year;'
    end

    arr = connection.exec_query(sql).to_a

    hash = arr.inject({}) { |memo, el| memo[el['year'].to_i] = el['count']; memo }
    (MIN_YEAR..MAX_YEAR).to_a.each do |year|
      hash[year] ||= 0
    end
    hash
  end

  def self.delete_all_for_year(year)
    connection.exec_query("delete from authors_books where book_id in (select id from books where year = #{year.to_i})")
    connection.exec_query("delete from books where year = #{year.to_i}")
  end

  private

  def set_first_letter
    self.first_letter = name.first
  end
end
