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
FOR EACH ROW
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
        WHERE show_id = OLD.show_id AND booked = 0
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
    )
END;


CREATE TRIGGER update_post_booking
AFTER INSERT ON Bookings
WHEN NEW.status IN ('booked', 'held')
FOR EACH ROW
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
        WHERE show_id = NEW.show_id AND booked = 0
    )
    -- WHERE id = NEW.show_id;
    WHERE id = (
        SELECT show_id
        FROM Tickets
        WHERE id = (
            SELECT ticket_id
            FROM Booking_Ticket
            WHERE booking_id = OLD.id
        )
    )
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



-- update available seats and ticket booked status if booking booked/held
-- CREATE TRIGGER update_show_available_seats_and_tickets_added
-- AFTER UPDATE OF status ON Bookings
-- WHEN OLD.status IN ('booked', 'held')
-- FOR EACH ROW
-- BEGIN
--     UPDATE Shows
--     SET available_seats = available_seats - (
--         SELECT COUNT(*)
--         FROM Booking_Ticket bt
--         JOIN Tickets t ON bt.ticket_id = t.id
--         WHERE bt.booking_id = OLD.id
--         AND t.booked = 0
--     )
--     WHERE id = (
--         SELECT show_id
--         FROM Tickets
--         WHERE id = (
--             SELECT ticket_id
--             FROM Booking_Ticket
--             WHERE booking_id = OLD.id
--         )
--     );

--     UPDATE Tickets
--     SET booked = 1
--     WHERE id IN (
--         SELECT ticket_id
--         FROM Booking_Ticket
--         WHERE booking_id = OLD.id
--     );
-- END;







-- -- Trigger: Update available seats after ticket insert 
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

-- -- Trigger: Update average rating in Movie
-- CREATE TRIGGER update_avg_rating_after_rating_change
-- AFTER INSERT OR DELETE OR UPDATE ON Ratings
-- FOR EACH ROW
-- BEGIN
--   IF (NEW.movie_id IS NOT NULL) THEN 
--     UPDATE Movie 
--     SET avg_rating = (SELECT AVG(rating) FROM Ratings WHERE movie_id = NEW.movie_id)
--     WHERE id = NEW.movie_id;
--   END IF;
-- END $$

-- DELIMITER ;



----
-- update available seats and ticket booked status if booking cancelled/dropped
-- CREATE TRIGGER update_show_available_seats_and_tickets_deleted
-- AFTER UPDATE OF status ON Bookings
-- WHEN OLD.status IN ('cancelled', 'dropped')
-- FOR EACH ROW
-- BEGIN
--     UPDATE Shows
--     SET available_seats = available_seats + (
--         SELECT COUNT(*)
--         FROM Booking_Ticket bt
--         JOIN Tickets t ON bt.ticket_id = t.id
--         WHERE bt.booking_id = OLD.id
--         AND t.booked = 1
--     )
--     WHERE id = (
--         SELECT show_id
--         FROM Tickets
--         WHERE id = (
--             SELECT ticket_id
--             FROM Booking_Ticket
--             WHERE booking_id = OLD.id
--         )
--     );

--     UPDATE Tickets
--     SET booked = 0
--     WHERE id IN (
--         SELECT ticket_id
--         FROM Booking_Ticket
--         WHERE booking_id = OLD.id
--     );
-- END;