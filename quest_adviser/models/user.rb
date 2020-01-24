require_relative("../db/sql_runner")

class User

  attr_reader :id
  attr_accessor :name

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save()
    sql = "INSERT INTO users
    (
      name
    )
    VALUES
    (
      $1
    )
    RETURNING id"
    values = [@name]
    user = SqlRunner.run( sql, values ).first
    @id = user['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM users"
    users = SqlRunner.run(sql)
    result = users.map { |user| User.new( user ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM users"
    SqlRunner.run(sql)
  end

  def locations
    sql = "select locations.* from locations
            INNER JOIN visits ON locations.id = visits.location_id
            WHERE visits.user_id = $1"
    values = [@id]

    result = SqlRunner.run(sql, values)

    location_objects_array = result.map { |row_hash| Location.new(row_hash) }

    return location_objects_array
  end

end
