require_relative('../db/sql_runner.rb')
require('pg')
require('pry')

class Movie

  attr_reader :id
  attr_accessor :title, :genre

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @title = options["title"]
    @genre = options["genre"]
    @budget = options['budget']
    @remaining_budget = @budget
  end

  def save
    sql = "INSERT INTO movies (title, genre)
            VALUES ($1, $2)
            RETURNING id"
    values = [@title, @genre]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def self.all
    sql = "SELECT * FROM movies"
    result = SqlRunner.run(sql)
    movies_array = result.map{|movie_hash| Movie.new(movie_hash)}
    return movies_array
  end

  def update
    sql = "UPDATE movies SET (title, genre) = ($1, $2)
    WHERE id = $3"
    values = [@title, @genre, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM movies"
    SqlRunner.run(sql)
  end

  def stars
    sql = "SELECT stars.* from stars
    INNER JOIN castings on stars.id = castings.star_id
    WHERE castings.movie_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    stars_results = result.map{|star_hash| Star.new(star_hash)}
    return stars_results
  end


  def check_budget
    # sql = "SELECT castings.* from movies
    # INNER JOIN castings on movies.id = castings.movie_id
    # WHERE castings.movie_id = $1"
    sql = "SELECT SUM(castings.fee) from movies
    INNER JOIN castings on movies.id = castings.movie_id
    WHERE castings.movie_id = $1;"

    values = [@id]

    result = SqlRunner.run(sql, values)

    @remaining_budget = @budget - result[0]["sum"].to_i

    return @remaining_budget
    # result.each{|hash|
    #   @budget -= hash['fee'].to_i
    #   # for k, v in hash
    #   #   if k == 'fee'
    #   #     @budget -= v.to_i
    #   #   end
    #   # end
    # }

  end

  # alternative method:
  # def castings()
  #   sql = "SELECT * FROM castings where movie_id = $1"
  #   values = [@id]
  #   casting_data = SqlRunner.run(sql, values)
  #   return casting_data.map{|casting| Casting.new(casting)}
  # end
  #
  # def remaining_budget()
  #   castings = self.castings()
  #   casting_fees = castings.map{|casting| casting.fee}
  #   combined_fees = casting_fees.sum
  #   return @budget - combined_fees
  # end

end
