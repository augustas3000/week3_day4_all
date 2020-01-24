DROP TABLE visits;
DROP TABLE users;
DROP TABLE locations;


CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE locations (
  id SERIAL PRIMARY KEY,
  category VARCHAR(255),
  name VARCHAR(255)
);

create table visits (
  id SERIAL PRIMARY KEY,
  user_id INT references users(id) ON DELETE CASCADE,
  location_id INT references locations(id) ON DELETE CASCADE,
  review TEXT
);

-- if we delete a user, thats gonna delete all records in visits - FOREIGN KEY dependence
-- ON DELETE CASCADE - if we delete a user, we want all visits of that user id to be deleted,
-- same with location.
