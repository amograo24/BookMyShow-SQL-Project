CREATE TABLE IF NOT EXISTS Theatres(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name TEXT NOT NULL,
    location TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS Audis(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name TEXT,
    theatre_id INTEGER NOT NULL,
    FOREIGN KEY(theatre_id) REFERENCES theatres(id)
);

-- Bookings Table
CREATE TABLE IF NOT EXISTS Bookings (
  id VARCHAR(40) PRIMARY KEY,
  customer_id VARCHAR(30) NOT NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('booked', 'cancelled', 'held', 'dropped')), -- held ka dekhna padega
  booking_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES Customers(id)
  -- the check condition for cancellation
  CHECK (booking_datetime <= (SELECT time_start FROM Shows WHERE show_id = (
    SELECT show_id FROM Tickets WHERE ticket_id = (
        SELECT ticket_id FROM Booking_Ticket WHERE booking_id = id
    )
  )))
);

-- change comment above the bookings_tickets table in master_schema.sql, it's incorrect