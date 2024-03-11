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