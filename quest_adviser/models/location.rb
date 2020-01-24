require_relative("../db/sql_runner")

class Location

  attr_reader :id
  attr_accessor :name, :category

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @category = options['category']
  end

  def save()
    sql = "INSERT INTO locations
    (
      name,
      category
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@name, @category]
    location = SqlRunner.run( sql, values ).first
    @id = location['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM locations"
    locations = SqlRunner.run(sql)
    result = locations.map { |location| Location.new( location ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM locations"
    SqlRunner.run(sql)
  end

  def users
    sql = "select users.*
          FROM users INNER JOIN visits
          ON visits.user_id = users.id
          WHERE visits.location_id = $1"
    values = [@id]

    users_data = SqlRunner.run(sql, values)
    result = users_data.map {|user| User.new(user)}
    return result
  end

  # a warapper/helper for standard .map syntax.
  # def self.map_items(location_data)
  #   result = location_data.map { |location| Location.new(location)}
  #   return result
  # end

  end

end
