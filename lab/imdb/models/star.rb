require_relative('../db/sql_runner.rb')
require('pg')
require('pry')

class Star

  attr_reader :id
  attr_accessor :first_name, :last_name

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @first_name = options["first_name"]
    @last_name = options["last_name"]
  end

  def save
    sql = "INSERT INTO stars (first_name, last_name)
            VALUES ($1, $2)
            RETURNING id"
    values = [@first_name, @last_name]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def self.all
    sql = 'SELECT * FROM stars'
    result = SqlRunner.run(sql)
    stars_array = result.map{|star_hash| Star.new(star_hash)}
    return stars_array
  end

  def update
    sql = "UPDATE stars SET (first_name, last_name) = ($1, $2)
    WHERE id = $3"
    values = [@first_name, @last_name, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = 'DELETE FROM stars'
    SqlRunner.run(sql)
  end

  def movies
    sql = 'SELECT movies.* FROM movies
    INNER JOIN castings ON movies.id = castings.movie_id
    WHERE castings.star_id = $1'
    values = [@id]
    result = SqlRunner.run(sql, values)
    movies_array = result.map{|movie| Movie.new(movie)}
    return movies_array
  end

end
