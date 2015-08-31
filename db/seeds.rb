require 'faker'

class Generator
  YEAR_FIRST = 1945
  YEAR_LAST = 2015

  AUTHORS = 100_000
  BOOKS = 4_000_000

  BATCH_SIZE = 10_000


  def create_authors
    sqls = []
    puts "Creating #{AUTHORS} authors"
    AUTHORS.times do |i|
      sqls << "insert into authors (name) values (#{ActiveRecord::Base.connection.quote(Faker::Name.name)});"
      if (i + 1) % BATCH_SIZE == 0
        ActiveRecord::Base.connection.execute(sqls.join(''))
        sqls = []
        puts "\tcreated #{i + 1} authors"
      end
    end

    if sqls.any?
      ActiveRecord::Base.connection.execute(sqls.join(''))
    end

    puts ''
  end

  def create_books
    sqls = []
    puts "Creating #{BOOKS} books"
    BOOKS.times do |i|
      name = Faker::Lorem.sentence(2, true, 6)
      year = rand(YEAR_LAST - YEAR_FIRST) + YEAR_FIRST
      sqls << "insert into books (name, year) values (#{ActiveRecord::Base.connection.quote(name)}, #{year});"

      if (i + 1) % BATCH_SIZE == 0
        ActiveRecord::Base.connection.execute(sqls.join(''))
        sqls = []
        puts "\tcreated #{i + 1} books"
      end
    end

    if sqls.any?
      ActiveRecord::Base.connection.execute(sqls.join(''))
    end

    puts ''
  end

  def create_authors_books
    author_min_id = Author.minimum(:id)
    author_max_id = Author.maximum(:id)
    book_min_id = Book.minimum(:id)
    book_max_id = Book.maximum(:id)

    sqls = []
    author_ids = (author_min_id..author_max_id).to_a
    puts 'Creating relations between books and authors'
    (book_min_id..book_max_id).each_with_index do |book_id, index|
      author_ids.sample(rand(3) + 1).each do |author_id|
        sqls << "insert into authors_books (author_id, book_id) values (#{author_id}, #{book_id});"
      end

      if (index + 1) % BATCH_SIZE == 0
        ActiveRecord::Base.connection.execute(sqls.join(''))
        sqls = []
        puts "\tcreated author relations for #{index + 1} books"
      end
    end

    if sqls.any?
      ActiveRecord::Base.connection.execute(sqls.join(''))
    end
  end

  def run
    ActiveRecord::Base.connection.execute('delete from authors_books')
    Book.delete_all
    Author.delete_all

    res = Benchmark.measure do
      create_authors
      create_books
      create_authors_books
    end

    puts res
  end
end

Generator.new.run
