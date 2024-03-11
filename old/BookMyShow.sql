CREATE TABLE Movie (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  director VARCHAR(255),
  rating DECIMAL(3,1), 
  release_date DATE
);

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

-- TRIGGERS 

DELIMITER $$

--Trigger: Update available seats after ticket insert 
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

DELIMITER ;
