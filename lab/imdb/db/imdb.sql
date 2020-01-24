DROP TABLE castings;
DROP TABLE movies;
DROP TABLE stars;

CREATE TABLE movies(
  id SERIAL PRIMARY KEY,
  title VARCHAR(255),
  genre VARCHAR(255),
  budget INT
);

CREATE TABLE stars(
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(255),
  last_name VARCHAR(255)
);

CREATE TABLE castings(
  id SERIAL PRIMARY KEY,
  movie_id INT references movies(id),
  star_id INT references stars(id),
  fee INT
);
