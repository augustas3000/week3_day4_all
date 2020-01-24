require('pg')
require_relative('models/casting.rb')
require_relative('models/movie.rb')
require_relative('models/star.rb')

Casting.delete_all()
Movie.delete_all()
Star.delete_all()

movie1 = Movie.new({'title' => 'Home Alone', 'genre' => 'comedy', 'budget' => 10000000})
movie1.save
movie2 = Movie.new({'title' => 'Home Alone 2', 'genre' => 'comedy', 'budget' => 90000000})
movie2.save

star1 = Star.new({'first_name' => 'Macaulay', 'last_name' => 'Culkin'})
star1.save
star2 = Star.new({'first_name' => 'Tim', 'last_name' => 'Curry'})
star2.save

casting1 = Casting.new({'movie_id' => movie1.id, 'star_id' => star1.id, 'fee' => 50000})
casting1.save
casting3 = Casting.new({'movie_id' => movie1.id, 'star_id' => star2.id, 'fee' => 50000})
casting3.save
casting2 = Casting.new({'movie_id' => movie2.id, 'star_id' => star2.id, 'fee' => 99})
casting2.save
casting3 = Casting.new({'movie_id' => movie2.id, 'star_id' => star1.id, 'fee' => 1})
casting3.save


p movie2.check_budget
