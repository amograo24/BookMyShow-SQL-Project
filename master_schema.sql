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
  -- we need to add another check: cancellation should be permitted only before the show time starts
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

-- update average rating
CREATE TRIGGER update_movie_avg 
AFTER INSERT ON Reviews
FOR EACH ROW
BEGIN
  UPDATE Movies
  SET avg_rating = (
    SELECT AVG(rating)
    FROM Reviews
    WHERE movie_id = NEW.movie_id
  )
  WHERE id = NEW.movie_id;
END;



CREATE TRIGGER update_post_cancelled_booking
AFTER UPDATE OF status ON Bookings
WHEN OLD.status IN ('cancelled', 'dropped')
BEGIN
    UPDATE Tickets
    SET booked = 0
    WHERE id IN (
        SELECT ticket_id
        FROM Booking_Ticket
        WHERE booking_id = OLD.id
    );

    UPDATE Shows
    SET available_seats = (
        SELECT COUNT(*) 
        FROM Tickets 
        -- WHERE show_id = OLD.show_id AND booked = 0
        WHERE show_id = (
            SELECT DISTINCT show_id FROM Tickets 
            JOIN Booking_Ticket ON Tickets.id = Booking_Ticket.ticket_id 
            WHERE Booking_Ticket.booking_id = OLD.id
        ) AND booked = 0
        
    )
    -- WHERE id = OLD.ticket_id.show_id;
    WHERE id = (
        SELECT show_id
        FROM Tickets
        WHERE id = (
            SELECT ticket_id
            FROM Booking_Ticket
            WHERE booking_id = OLD.id
        )
    );
END;


CREATE TRIGGER update_post_booking
AFTER INSERT ON Bookings
WHEN NEW.status IN ('booked', 'held')
BEGIN
    UPDATE Tickets
    SET booked = 1
    WHERE id IN (
        SELECT ticket_id
        FROM Booking_Ticket
        WHERE booking_id = NEW.id
    );

    UPDATE Shows
    SET available_seats = (
        SELECT COUNT(*) 
        FROM Tickets 
        WHERE show_id = (
            SELECT DISTINCT show_id FROM Tickets 
            JOIN Booking_Ticket ON Tickets.id = Booking_Ticket.ticket_id 
            WHERE Booking_Ticket.booking_id = NEW.id
        )
        -- WHERE show_id = ( -- other alternative would be join
        --     SELECT DISTINCT show_id FROM Tickets
        --     WHERE ticket_id IN (
        --         SELECT ticket_id FROM bookings_tickets
        --         WHERE booking_id = NEW.id
        --     )
        -- ) AND booked = 0
    )
    -- WHERE id = NEW.show_id;
    WHERE id = (
        SELECT show_id
        FROM Tickets
        WHERE id = (
            SELECT ticket_id
            FROM Booking_Ticket
            WHERE booking_id = NEW.id
        )
    );
END;

CREATE TRIGGER update_available_seats_post_show_addition AFTER INSERT ON Shows
FOR EACH ROW
BEGIN
  UPDATE Shows
  SET available_seats = (
    SELECT COUNT(*)
    FROM Seats
    WHERE audi_id = NEW.audi_id
  )
  WHERE id = NEW.id;
END;

CREATE VIEW WeeklyOccupancyRates AS
SELECT m.title, ((SELECT COUNT(*) FROM Tickets T JOIN Shows S ON T.show_id = S.id WHERE S.movie_id = m.id AND T.booked = 1 AND S.time_start >= datetime('now','-7 days'))/ (SELECT COUNT(*) FROM Tickets T JOIN Shows S ON T.show_id = S.id WHERE S.movie_id = m.id AND S.time_start >= datetime('now','-7 days')))*100 
AS occupancy_rate FROM movies m
JOIN shows s
ON s.movie_id =  m.id
JOIN tickets t
ON t.show_id = s.id
GROUP BY m.id;

CREATE VIEW AllTimeBoxOffice AS
SELECT S.movie_id, SUM(T.price) AS total_box_office
FROM Shows S
JOIN Tickets T ON S.id = T.show_id
JOIN
Booking_Ticket BT ON T.id = BT.ticket_id
JOIN Bookings B ON BT.booking_id = B.id
WHERE B.status = 'booked'
GROUP BY S.movie_id;

CREATE VIEW LastMonthBoxOffice AS
SELECT S.movie_id, SUM(T.price) AS weekly_box_office
FROM Shows S
JOIN Tickets T ON S.id = T.show_id
JOIN Booking_Ticket BT ON T.id = BT.ticket_id
JOIN Bookings B ON BT.booking_id = B.id
WHERE B.status = 'booked' AND S.time_start >= datetime('now','-1 month')
GROUP BY S.movie_id;


CREATE VIEW LastWeekBoxOffice AS
SELECT S.movie_id, SUM(T.price) AS weekly_box_office
FROM Shows S
JOIN Tickets T ON S.id = T.show_id
JOIN Booking_Ticket BT ON T.id = BT.ticket_id
JOIN Bookings B ON BT.booking_id = B.id
WHERE B.status = 'booked' AND S.time_start >= datetime('now','-7 days')
GROUP BY S.movie_id;

CREATE VIEW DailyTicketsSoldPerPeriod AS
SELECT 
    DATE(Shows.time_start) AS sale_date,
    CASE 
        WHEN HOUR(Shows.time_start) >= 6 AND HOUR(Shows.time_start) < 9 THEN '6AM-9AM'
        WHEN HOUR(Shows.time_start) >= 9 AND HOUR(Shows.time_start) < 12 THEN '9AM-12PM'
        WHEN HOUR(Shows.time_start) >= 12 AND HOUR(Shows.time_start) < 15 THEN '12PM-3PM'
        WHEN HOUR(Shows.time_start) >= 15 AND HOUR(Shows.time_start) < 18 THEN '3PM-6PM'
        WHEN HOUR(Shows.time_start) >= 18 AND HOUR(Shows.time_start) < 21 THEN '6PM-9PM'
        WHEN HOUR(Shows.time_start) >= 21 AND HOUR(Shows.time_start) < 24 THEN '9PM-12AM'
        WHEN HOUR(Shows.time_start) >= 0 AND HOUR(Shows.time_start) < 3 THEN '12AM-3AM'
        WHEN HOUR(Shows.time_start) >= 3 AND HOUR(Shows.time_start) < 6 THEN '3AM-6AM'
        -- ... Add more cases for further periods
        -- ELSE 'Other' 
    END AS time_period, 
    COUNT(*) AS tickets_sold
FROM Shows
JOIN Tickets ON Shows.id = Tickets.show_id 
WHERE Tickets.booked = TRUE -- Assuming 'booked' indicates a confirmed sale
GROUP BY sale_date, time_period;


CREATE VIEW WeeklyTicketsByTheatre AS
SELECT 
   Theatres.name AS theatre_name,
   COUNT(*) AS tickets_sold
FROM Shows
JOIN Tickets ON Shows.id = Tickets.show_id
JOIN Audis ON Shows.audi_id = Audis.id
JOIN Theatres ON Audis.theatre_id = Theatres.id
WHERE Shows.time_start >= datetime('now','-7 days')
  AND Tickets.booked = TRUE 
GROUP BY Theatres.name 
ORDER BY tickets_sold DESC; 


CREATE VIEW WeeklyTicketsByCity AS
SELECT Cities.name AS city_name, COUNT(*) AS tickets_sold
FROM Shows
JOIN Tickets ON Shows.id = Tickets.show_id
JOIN Audis ON Shows.audi_id = Audis.id
JOIN Theatres ON Audis.theatre_id = Theatres.id
JOIN Cities ON Theatres.city_id = Cities.id 
WHERE Shows.time_start >= datetime('now','-7 days') AND Tickets.booked = TRUE 
GROUP BY Cities.name
ORDER BY tickets_sold DESC;


CREATE VIEW WeeklyTicketsByMovie AS
SELECT Movies.title AS movie_title, COUNT(*) AS tickets_sold
FROM Shows
JOIN Tickets ON Shows.id = Tickets.show_id
JOIN Movies ON Shows.movie_id = Movies.id
WHERE Shows.time_start >= datetime('now','-7 days') AND Tickets.booked = TRUE 
GROUP BY Movies.title
ORDER BY tickets_sold DESC;

-- Optimize trigger on update available seats
CREATE INDEX show_seats ON Shows(available_seats);
CREATE INDEX audi_seat ON Seats(audi_id);
-- Optimize on updating ticket status
CREATE INDEX update_booked ON Tickets(booked);
-- Optimize box office calculations
CREATE INDEX ticket_price ON Tickets(price);