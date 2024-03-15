-- Optimize trigger on update available seats, only slows down the initialization of seats
CREATE INDEX show_seats ON Shows(available_seats)
CREATE INDEX audi_seat ON Seats(audi_id)
CREATE INDEX ticket_seat ON Tickets(seat_id)

-- Optimize on updating ticket status, only slows down ticket generation
CREATE INDEX update_booked ON Tickets(booked)

-- Optimize on updating booking status, even though it might slow down the process of making a new booking
-- can remove
CREATE INDEX update_status ON Bookings(status)

-- Optimize box office calculations
CREATE INDEX ticket_price ON Tickets(price)

