-- States
INSERT INTO States (name) VALUES ('New York');

-- Cities 
INSERT INTO Cities (name, state_id) VALUES ('Albany', 1); -- Assumes 'New York' has id 1 

-- Genres
INSERT INTO Genres (name) VALUES ('Drama');

-- Customers
INSERT INTO Customers (id, name, email, phone_number, date_of_birth, gender) 
VALUES ('CUST001', 'John Smith', 'john.smith@example.com', '+19876543210', '1990-05-12', 'M');

-- Languages
INSERT INTO Languages (name) VALUES ('English');

-- Movies
INSERT INTO Movies (id, title, director, avg_rating, release_date, duration, certification)
VALUES ('MV001', 'The Pursuit of Happiness', 'Gabriele Muccino', 7.8, '2006-12-15', '01:57:00', 'PG-13');

-- Reviews
INSERT INTO Reviews (customer_id, movie_id, rating, comment)
VALUES ('CUST001', 'MV001', 8.5, 'A heartwarming and inspirational story!'); 

-- Theatres
INSERT INTO Theatres (id, name, city_id, address)
VALUES ('TH001', 'Regal Cinemas', 1, '123 Main Street, Albany, NY'); 

-- Audis
INSERT INTO Audis (id, name, theatre_id)
VALUES ('AUD001', 'Audi 2', 'TH001');

-- Seats
INSERT INTO Seats (name, audi_id)
VALUES ('B4', 'AUD001');

-- Shows
INSERT INTO Shows (id, movie_id, audi_id, time_start, time_end, available_seats)
VALUES ('SHOW001', 'MV001', 'AUD001', '2024-03-16 18:00:00', '2024-03-16 20:57:00', 30);  

-- Tickets
INSERT INTO Tickets (id, show_id, seat_id, price) -- Assuming seat exists
VALUES ('TCKT001', 'SHOW001', 1, 12.50); 

-- Bookings
INSERT INTO Bookings (id, customer_id, status, booking_datetime)
VALUES ('BOOK001', 'CUST001', 'booked', '2024-03-16 12:30:00');  

-- Movie_Genre
INSERT INTO Movie_Genre (movie_id, genre_id) 
VALUES ('MV001', 1); -- Assuming 'Drama' has id 1

-- Movie_Language
INSERT INTO Movie_Language (movie_id, language_id)
VALUES ('MV001', 1); -- Assuming 'English' has id 1

-- Booking_Ticket
INSERT INTO Booking_Ticket (booking_id, ticket_id)
VALUES ('BOOK001', 'TCKT001');