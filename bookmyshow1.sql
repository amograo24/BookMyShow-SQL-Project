-- Customer Table
CREATE TABLE Customer (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  phone_number VARCHAR(15),
  dob DATE,
  date_of_joining DATE NOT NULL
);

-- Movie Table
CREATE TABLE Movie (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  director VARCHAR(255),
  avg_rating DECIMAL(2, 1), 
  release_date DATE
);

-- Language Table
CREATE TABLE Language (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL
);

-- Movie_Language Table (Many-to-Many)
CREATE TABLE Movie_Language (
  movie_id INT NOT NULL,
  language_id INT NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES Movie(id),
  FOREIGN KEY (language_id) REFERENCES Language(id),
  PRIMARY KEY (movie_id, language_id)
);

-- Genre Table 
CREATE TABLE Genre (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL
);

-- Movie_Genre Table (Many-to-Many)
CREATE TABLE Movie_Genre (
  movie_id INT NOT NULL,
  genre_id INT NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES Movie(id),
  FOREIGN KEY (genre_id) REFERENCES Genre(id),
  PRIMARY KEY (movie_id, genre_id)
);

-- City Table
CREATE TABLE City (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL
);

-- State Table
CREATE TABLE State (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL
);

-- City_State Table (Many-to-One)
CREATE TABLE City_State (
  city_id INT NOT NULL,
  state_id INT NOT NULL,
  FOREIGN KEY (city_id) REFERENCES City(id),
  FOREIGN KEY (state_id) REFERENCES State(id),
  PRIMARY KEY (city_id)
);

-- Audi Table
CREATE TABLE Audi (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  city_id INT NOT NULL,
  total_seats INT NOT NULL,
  FOREIGN KEY (city_id) REFERENCES City(id)
);

-- Show Table
CREATE TABLE Show (
  id INT PRIMARY KEY AUTO_INCREMENT,
  movie_id INT NOT NULL,
  audi_id INT NOT NULL,
  time_start DATETIME NOT NULL,
  time_end DATETIME NOT NULL,
  base_price DECIMAL(10, 2) NOT NULL,
  available_seats INT NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES Movie(id),
  FOREIGN KEY (audi_id) REFERENCES Audi(id),
  CHECK (time_end > time_start)
);

-- Seats Table
CREATE TABLE Seats (
  id INT PRIMARY KEY AUTO_INCREMENT,
  show_id INT NOT NULL,
  seat_number VARCHAR(10) NOT NULL,
  is_booked BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (show_id) REFERENCES Show(id)
);

-- Ratings Table
CREATE TABLE Ratings (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,  
  movie_id INT NOT NULL,
  rating DECIMAL(2, 1) NOT NULL,
  rating_datetime DATETIME NOT NULL,  
  FOREIGN KEY (user_id) REFERENCES Customer(id), 
  FOREIGN KEY (movie_id) REFERENCES Movie(id)
);

-- Bookings Table
CREATE TABLE Bookings (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  ticket_id INT NOT NULL, 
  status VARCHAR(20) NOT NULL CHECK (status IN ('booked', 'cancelled', 'initiated')), 
  booking_datetime DATETIME NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES Customer(id),
  FOREIGN KEY (ticket_id) REFERENCES Tickets(id) 
);

-- Tickets Table 
CREATE TABLE Tickets (
 id INT PRIMARY KEY AUTO_INCREMENT,
 show_id INT NOT NULL,
 seat_id INT NOT NULL,
 customer_id INT NOT NULL, 
 booked_at DATETIME NOT NULL,
 FOREIGN KEY (show_id) REFERENCES Show(id),
 FOREIGN KEY (seat_id) REFERENCES Seats(id),
 FOREIGN KEY (customer_id) REFERENCES Customer(id) 
); 

-- Many-to-Many table between Bookings and Tickets
CREATE TABLE Booking_Ticket (
  booking_id INT NOT NULL,
  ticket_id INT NOT NULL,
  FOREIGN KEY (booking_id) REFERENCES Bookings(id),
  FOREIGN KEY (ticket_id) REFERENCES Tickets(id),
  PRIMARY KEY (booking_id, ticket_id)
);

-- ... (All the table creation code from the previous response) ...

-- TRIGGERS --

DELIMITER $$

-- Trigger: Update available seats after ticket insert 
CREATE TRIGGER update_available_seats_after_ticket_insert
AFTER INSERT ON Tickets
FOR EACH ROW
BEGIN
    UPDATE Show
    SET available_seats = available_seats - 1
    WHERE id = NEW.show_id;
END $$

-- Trigger: Update available seats after ticket delete 
CREATE TRIGGER update_available_seats_after_ticket_delete
AFTER DELETE ON Tickets
FOR EACH ROW
BEGIN
    UPDATE Show
    SET available_seats = available_seats + 1
    WHERE id = OLD.show_id;
END $$

-- Trigger: Update average rating in Movie
CREATE TRIGGER update_avg_rating_after_rating_change
AFTER INSERT OR DELETE OR UPDATE ON Ratings
FOR EACH ROW
BEGIN
  IF (NEW.movie_id IS NOT NULL) THEN 
    UPDATE Movie 
    SET avg_rating = (SELECT AVG(rating) FROM Ratings WHERE movie_id = NEW.movie_id)
    WHERE id = NEW.movie_id;
  END IF;
END $$

DELIMITER ;
