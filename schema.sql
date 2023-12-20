CREATE TABLE categories(
  id serial PRIMARY KEY,
  name text NOT NULL UNIQUE
);

CREATE TABLE contacts(
  id serial PRIMARY KEY,
  name text NOT NULL,
  phone_number integer NOT NULL,
  email text NOT NULL,
  category_id integer REFERENCES categories(id) NOT NULL
);

