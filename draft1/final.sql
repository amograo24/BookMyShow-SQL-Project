-- State Table
CREATE TABLE IF NOT EXISTS States (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  name VARCHAR(50) UNIQUE NOT NULL 
);

-- City Table
CREATE TABLE IF NOT EXISTS Cities (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  name VARCHAR(75) NOT NULL,
  state_id INTEGER NOT NULL,
  FOREIGN KEY (state_id) REFERENCES States(id)
);

-- Genre Table
CREATE TABLE IF NOT EXISTS Genres (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  name VARCHAR(50) UNIQUE NOT NULL
);

-- Customer Table
CREATE TABLE IF NOT EXISTS Customers (
  id VARCHAR(30) PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone_number VARCHAR(14) UNIQUE NOT NULL,
  date_of_birth DATE NOT NULL,
  date_of_joining DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  gender CHAR(1) NOT NULL,
  CHECK ((email LIKE '%@%') AND (phone_number GLOB '+[0-9]*') AND (gender in ('M', 'F', 'O')) AND (LENGTH(phone_number)>=12))
);

-- Language Table
CREATE TABLE IF NOT EXISTS Languages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(50) UNIQUE NOT NULL
);

-- Movie Table
CREATE TABLE IF NOT EXISTS Movies (
  id VARCHAR(20) PRIMARY KEY NOT NULL,
  title VARCHAR(255) NOT NULL,
  director VARCHAR(255),
  avg_rating DECIMAL(4, 2), -- this we gotta check once
  release_date DATE NOT NULL, -- 'yyyy-mm-dd'
  duration TIME NOT NULL, -- 'hh:mm:ss'
  certification VARCHAR(3) NOT NULL CHECK (certification IN ('U', 'U/A', 'A', 'S')),
  CHECK (avg_rating >= 0 AND avg_rating <= 10)
);

-- Rating Table (Review Table)
CREATE TABLE IF NOT EXISTS Reviews (
  id VARCHAR(40) PRIMARY KEY NOT NULL,
  customer_id VARCHAR(30),  -- can be null as anonymous comment?
  movie_id VARCHAR(20) NOT NULL,
  rating DECIMAL(4, 2) NOT NULL,
  time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  
  comment TEXT,
  FOREIGN KEY (customer_id) REFERENCES Customers(id), 
  FOREIGN KEY (movie_id) REFERENCES Movies(id)
  CHECK (rating >= 0 AND rating <= 10)
);

-- Theatre Table
CREATE TABLE IF NOT EXISTS Theatres (
  id VARCHAR(20) PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL,
  city_id INTEGER NOT NULL,
  address TEXT NOT NULL,
  FOREIGN KEY (city_id) REFERENCES Cities(id)
);

-- Audi Table
CREATE TABLE IF NOT EXISTS Audis (
  id VARCHAR(30) PRIMARY KEY NOT NULL,
  name VARCHAR(20) NOT NULL,
  theatre_id VARCHAR(20) NOT NULL,
  FOREIGN KEY (theatre_id) REFERENCES Threatres(id)
);

-- Seats Table
CREATE TABLE IF NOT EXISTS Seats (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  name VARCHAR(5) NOT NULL,
  audi_id VARCHAR(30) NOT NULL,
  FOREIGN KEY (audi_id) REFERENCES Audis(id)
);

-- Show Table
CREATE TABLE IF NOT EXISTS Shows (
  id VARCHAR(40) PRIMARY KEY NOT NULL,
  movie_id VARCHAR(20) NOT NULL,
  audi_id VARCHAR(30) NOT NULL,
  time_start DATETIME NOT NULL,
  time_end DATETIME NOT NULL,
  -- available_seats INTEGER NOT NULL DEFAULT (SELECT COUNT(*) FROM Seats WHERE audi_id = Shows.audi_id),
  available_seats INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (movie_id) REFERENCES Movies(id),
  FOREIGN KEY (audi_id) REFERENCES Audis(id),
  CHECK (time_end > time_start AND available_seats >= 0)
);

-- Tickets Table 
CREATE TABLE IF NOT EXISTS Tickets (
 id VARCHAR(40) PRIMARY KEY NOT NULL,
 show_id VARCHAR(40) NOT NULL,
 seat_id INTEGER NOT NULL,
 booked BOOLEAN DEFAULT FALSE NOT NULL,
 price DECIMAL(10, 2) NOT NULL CHECK(price >= 0),
 FOREIGN KEY (show_id) REFERENCES Shows(id),
 FOREIGN KEY (seat_id) REFERENCES Seats(id)
); 

-- Bookings Table
CREATE TABLE IF NOT EXISTS Bookings (
  id VARCHAR(40) PRIMARY KEY,
  customer_id VARCHAR(30) NOT NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('booked', 'cancelled', 'held', 'dropped')), -- held ka dekhna padega
  booking_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES Customers(id)
);

-- Movie_Genre Table (Many-to-Many)
CREATE TABLE IF NOT EXISTS Movie_Genre (
  movie_id VARCHAR(20) NOT NULL,
  genre_id INTEGER NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES Movies(id),
  FOREIGN KEY (genre_id) REFERENCES Genres(id),
  PRIMARY KEY (movie_id, genre_id)
);

-- Movie_Language Table (Many-to-Many)
CREATE TABLE IF NOT EXISTS Movie_Language (
  movie_id VARCHAR(20) NOT NULL,
  language_id INTEGER NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES Movies(id),
  FOREIGN KEY (language_id) REFERENCES Languages(id),
  PRIMARY KEY (movie_id, language_id)
);

-- Movie_Language Table (Many-to-Many)
CREATE TABLE IF NOT EXISTS Booking_Ticket (
  booking_id VARCHAR(40) NOT NULL,
  ticket_id VARCHAR(40) NOT NULL,
  FOREIGN KEY (booking_id) REFERENCES Bookings(id),
  FOREIGN KEY (ticket_id) REFERENCES Tickets(id),
  PRIMARY KEY (booking_id, ticket_id)
);


-- queries, views, triggers, ppt, final check