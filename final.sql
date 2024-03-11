-- State Table
CREATE TABLE State (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL
);

-- City Table
CREATE TABLE City (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  state_id INT NOT NULL,
  FOREIGN KEY (state_id) REFERENCES State(id)
);

-- Genre Table
CREATE TABLE Genre (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL
);

-- Customer Table
CREATE TABLE Customer (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  phone_number VARCHAR(15),
  dob DATE,
  date_of_joining DATE NOT NULL
  gender VARCHAR(10)
--   ADD Checks and other constraints
);

-- Language Table
CREATE TABLE Language (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL
);

-- Movie Table
CREATE TABLE Movie (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  director VARCHAR(255),
  avg_rating DECIMAL(2, 1), 
  release_date DATE
  duration FLOAT NOT NULL,
);

-- Rating Table (Review Table)
CREATE TABLE Ratings (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,  
  movie_id INT NOT NULL,
  rating DECIMAL(2, 1) NOT NULL, -- make this score?
  rating_datetime DATETIME NOT NULL,  
  comment TEXT,
  FOREIGN KEY (user_id) REFERENCES Customer(id), 
  FOREIGN KEY (movie_id) REFERENCES Movie(id)
);

-- Theatre Table
CREATE TABLE Theatre (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  city INT NOT NULL,
  address TEXT NOT NULL,
  FOREIGN KEY (city) REFERENCES City(id)
);

-- Audi Table
CREATE TABLE Audi (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  theatre_id INT NOT NULL,
  total_seats INT NOT NULL,
  FOREIGN KEY (theatre_id) REFERENCES Threatre(id)
);

-- Seats Table
CREATE TABLE Seats (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(10) NOT NULL,
  audi_id INT NOT NULL,
--   is_booked BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (audi_id) REFERENCES Audi(id)
);

-- Show Table
CREATE TABLE Show (
  id INT PRIMARY KEY,
  movie_id INT NOT NULL,
  audi_id INT NOT NULL,
  time_start DATETIME NOT NULL,
  time_end DATETIME NOT NULL,
  available_seats INT NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES Movie(id),
  FOREIGN KEY (audi_id) REFERENCES Audi(id),
  CHECK (time_end > time_start)
);

-- Tickets Table 
CREATE TABLE Tickets (
 id INT PRIMARY KEY,
 show_id INT NOT NULL,
 seat_id INT NOT NULL,
--  customer_id INT NOT NULL, 
 booked BOOLEAN DEFAULT FALSE,
 base_price DECIMAL(10, 2) NOT NULL,
 FOREIGN KEY (show_id) REFERENCES Show(id),
 FOREIGN KEY (seat_id) REFERENCES Seats(id),
 FOREIGN KEY (customer_id) REFERENCES Customer(id) 
); 

-- Bookings Table
CREATE TABLE Bookings (
  id INT PRIMARY KEY,
  customer_id INT NOT NULL,
--   ticket_id INT NOT NULL, 
  status VARCHAR(20) NOT NULL CHECK (status IN ('booked', 'cancelled', 'initiated')), 
  booking_datetime DATETIME NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES Customer(id),
  FOREIGN KEY (ticket_id) REFERENCES Tickets(id) 
);

-- Movie_Genre Table (Many-to-Many)
CREATE TABLE Movie_Genre (
  movie_id INT NOT NULL,
  genre_id INT NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES Movie(id),
  FOREIGN KEY (genre_id) REFERENCES Genre(id),
  PRIMARY KEY (movie_id, genre_id)
);

-- Movie_Language Table (Many-to-Many)
CREATE TABLE Movie_Language (
  movie_id INT NOT NULL,
  language_id INT NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES Movie(id),
  FOREIGN KEY (language_id) REFERENCES Language(id),
  PRIMARY KEY (movie_id, language_id)
);

-- Movie_Language Table (Many-to-Many)
CREATE TABLE Booking_Ticket (
  booking_id INT NOT NULL,
  ticket_id INT NOT NULL,
  FOREIGN KEY (booking_id) REFERENCES Bookings(id),
  FOREIGN KEY (ticket_id) REFERENCES Tickets(id),
  PRIMARY KEY (booking_id, ticket_id)
);


-- queries, views, triggers, ppt, final check