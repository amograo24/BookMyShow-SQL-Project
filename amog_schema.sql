-- first draft, will be fine tuned and checks will be added asap!

CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(255),
    genre VARCHAR(100),
    release_date DATE,
    duration_minutes INT
);

CREATE TABLE Multiplexes (
    multiplex_id INT PRIMARY KEY,
    name VARCHAR(255),
    location VARCHAR(255)
);

CREATE TABLE Shows (
    show_id INT PRIMARY KEY,
    movie_id INT,
    multiplex_id INT,
    show_time DATETIME,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (multiplex_id) REFERENCES Multiplexes(multiplex_id)
);

CREATE TABLE Audis (
    audi_id INT PRIMARY KEY,
    multiplex_id INT,
    audi_number INT,
    capacity INT,
    FOREIGN KEY (multiplex_id) REFERENCES Multiplexes(multiplex_id)
);

CREATE TABLE Seats (
    seat_id INT PRIMARY KEY,
    audi_id INT,
    seat_number VARCHAR(10),
    FOREIGN KEY (audi_id) REFERENCES Audis(audi_id)
);

CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,
    show_id INT,
    seat_id INT,
    price DECIMAL(8, 2),
    booked BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (show_id) REFERENCES Shows(show_id),
    FOREIGN KEY (seat_id) REFERENCES Seats(seat_id)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(15),
    -- date of birth
    -- gender
    CONSTRAINT chk_email CHECK (email LIKE '%@%'),
    CONSTRAINT chk_phone CHECK (phone ~ '^(\+\d{12,13})$')
);

CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    customer_id INT,
    ticket_id INT,
    booking_date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);


-- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- 

-- CREATE TABLE IF NOT EXISTS theatres(
--     "id" INTEGER,
--     "name" TEXT NOT NULL,
--     "location" TEXT NOT NULL,
--     PRIMARY KEY("id")
-- );
-- CREATE TABLE IF NOT EXISTS audis(
--     "id" INTEGER,
--     "name" TEXT,
--     "theatre_id" INTEGER NOT NULL,
--     PRIMARY KEY("id"),
--     FOREIGN KEY("theatre_id") REFERENCES "theatres"("id")
-- )

-- -- -- -- -- -- 
-- -- -- -- -- -- 

-- CREATE TABLE Movie (
--   id INT PRIMARY KEY AUTO_INCREMENT,
--   name VARCHAR(255) NOT NULL,
--   director VARCHAR(255),
--   rating DECIMAL(3,1), 
--   release_date DATE
-- );

-- CREATE TABLE Show (
--   id INT PRIMARY KEY AUTO_INCREMENT,
--   movie_id INT NOT NULL,
--   audi_id INT NOT NULL,
--   time_start DATETIME NOT NULL,
--   time_end DATETIME NOT NULL,
--   base_price DECIMAL(10, 2) NOT NULL,
--   available_seats INT NOT NULL, 
--   FOREIGN KEY (movie_id) REFERENCES Movie(id),
--   FOREIGN KEY (audi_id) REFERENCES Audi(id), 
--   CHECK (time_end > time_start)
-- );

-- -- TRIGGERS 

-- DELIMITER $$

-- --Trigger: Update available seats after ticket insert 
-- CREATE TRIGGER update_available_seats_after_ticket_insert 
-- AFTER INSERT ON Tickets
-- FOR EACH ROW
-- BEGIN
--     UPDATE Show 
--     SET available_seats = available_seats - 1
--     WHERE id = NEW.show_id; 
-- END $$

-- -- Trigger: Update available seats after ticket delete 
-- CREATE TRIGGER update_available_seats_after_ticket_delete
-- AFTER DELETE ON Tickets
-- FOR EACH ROW
-- BEGIN
--     UPDATE Show 
--     SET available_seats = available_seats + 1
--     WHERE id = OLD.show_id;
-- END $$

-- DELIMITER ;
