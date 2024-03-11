-- CHANGE FOREIGN KEY TYPES (done?)
-- State Table
CREATE TABLE State (
  id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  name VARCHAR(50) UNIQUE NOT NULL 
);

-- City Table
CREATE TABLE City (
  id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  name VARCHAR(75) NOT NULL,
  state_id INT NOT NULL,
  FOREIGN KEY (state_id) REFERENCES State(id)
);

-- Genre Table
CREATE TABLE Genre (
  id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  name VARCHAR(50) UNIQUE NOT NULL
  -- let the name itself be the ID? also it should be unique...same applies for state?
);

-- Customer Table
CREATE TABLE Customer (
  id VARCHAR(30) PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone_number VARCHAR(14) UNIQUE NOT NULL,
  date_of_birth DATE NOT NULL,
  date_of_joining DATETIME NOT NULL,
  gender CHAR(1) NOT NULL,
  CHECK ((email LIKE '%@%') AND (phone_number GLOB '+[0-9]*') AND (gender in ('M', 'F', 'O')) AND (LENGTH(phone_number)>=13)),

  -- CONSTRAINT chk_email CHECK (email LIKE '%@%'),
  -- CONSTRAINT chk_phone CHECK (phone_number GLOB '+[0-9]*'),
  -- CONSTRAINT chck_gender CHECK (gender in ('M', 'F', 'O'))

  -- CONSTRAINT chk_phone CHECK (phone regexp '^(\+\d{12,13})$') -- this has to be checked
  -- CONSTRAINT chk_phone CHECK (phone_number LIKE '+%'),
);

-- Language Table
CREATE TABLE Language (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) UNIQUE NOT NULL
);

-- Movie Table
CREATE TABLE Movie (
  id VARCHAR(20) PRIMARY KEY NOT NULL,
  title VARCHAR(255) NOT NULL,
  director VARCHAR(255),
  avg_rating DECIMAL(4, 2), -- this we gotta check once
  release_date DATE NOT NULL,
  duration TIME NOT NULL,
  certification VARCHAR(3) NOT NULL CHECK (certification IN ('U', 'U/A', 'A', 'S')),
);

-- Rating Table (Review Table)
CREATE TABLE Reviews (
  id VARCHAR(40) PRIMARY KEY AUTO_INCREMENT NOT NULL,
  customer_id VARCHAR(30),  -- can be null as anonymous comment?
  movie_id VARCHAR(20) NOT NULL,
  rating DECIMAL(4, 2) NOT NULL,
  time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  
  comment TEXT,
  FOREIGN KEY (customer_id) REFERENCES Customer(id), 
  FOREIGN KEY (movie_id) REFERENCES Movie(id)
);

-- Theatre Table
CREATE TABLE Theatre (
  id VARCHAR(20) PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL,
  city_id INT NOT NULL,
  address TEXT NOT NULL,
  FOREIGN KEY (city_id) REFERENCES City(id)
);

-- Audi Table
CREATE TABLE Audi (
  id VARCHAR(30) PRIMARY KEY NOT NULL,
  name VARCHAR(50) NOT NULL,
  theatre_id VARCHAR(20) NOT NULL,
  total_seats INT NOT NULL,
  FOREIGN KEY (theatre_id) REFERENCES Threatre(id)
);

-- Seats Table
CREATE TABLE Seats (
  id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  name VARCHAR(5) NOT NULL,
  audi_id VARCHAR(30) NOT NULL,
  FOREIGN KEY (audi_id) REFERENCES Audi(id)
);

-- Show Table
CREATE TABLE Show (
  id VARCHAR(40) PRIMARY KEY NOT NULL,
  movie_id VARCHAR(20) NOT NULL,
  audi_id VARCHAR(30) NOT NULL,
  time_start DATETIME NOT NULL,
  time_end DATETIME NOT NULL,
  available_seats INT NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES Movie(id),
  FOREIGN KEY (audi_id) REFERENCES Audi(id),
  CHECK (time_end > time_start AND available_seats >= 0)
);

-- Tickets Table 
CREATE TABLE Tickets (
 id VARCHAR(40) PRIMARY KEY NOT NULL,
 show_id VARCHAR(40) NOT NULL,
 seat_id INT NOT NULL,
--  customer_id INT NOT NULL, 
 booked BOOLEAN DEFAULT FALSE NOT NULL,
 price DECIMAL(10, 2) NOT NULL CHECK(price >= 0),
 FOREIGN KEY (show_id) REFERENCES Show(id),
 FOREIGN KEY (seat_id) REFERENCES Seats(id),
--  FOREIGN KEY (customer_id) REFERENCES Customer(id) 
); 

-- Bookings Table
CREATE TABLE Bookings (
  id VARCHAR(40) PRIMARY KEY,
  customer_id VARCHAR(30) NOT NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('booked', 'cancelled', 'held', 'dropped')), -- held ka dekhna padega
  booking_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES Customer(id),
  -- FOREIGN KEY (ticket_id) REFERENCES Tickets(id) 
);

-- Movie_Genre Table (Many-to-Many)
CREATE TABLE Movie_Genre (
  movie_id VARCHAR(20) NOT NULL,
  genre_id INT NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES Movie(id),
  FOREIGN KEY (genre_id) REFERENCES Genre(id),
  PRIMARY KEY (movie_id, genre_id) NOT NULL
);

-- Movie_Language Table (Many-to-Many)
CREATE TABLE Movie_Language (
  movie_id VARCHAR(20) NOT NULL,
  language_id INT NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES Movie(id),
  FOREIGN KEY (language_id) REFERENCES Language(id),
  PRIMARY KEY (movie_id, language_id) NOT NULL
);

-- Movie_Language Table (Many-to-Many)
CREATE TABLE Booking_Ticket (
  booking_id VARCHAR(40) NOT NULL,
  ticket_id VARCHAR(40) NOT NULL,
  FOREIGN KEY (booking_id) REFERENCES Bookings(id),
  FOREIGN KEY (ticket_id) REFERENCES Tickets(id),
  PRIMARY KEY (booking_id, ticket_id) NOT NULL
);


-- queries, views, triggers, ppt, final check