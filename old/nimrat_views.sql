CREATE VIEW WeeklyOccupancyRates AS
SELECT m.title, ((SELECT COUNT(*) FROM Tickets T JOIN Shows S ON T.show_id = S.id WHERE S.movie_id = m.id AND T.booked = 1 AND S.time_start >= datetime('now','-7 days'))/ (SELECT COUNT(*) FROM Tickets T JOIN Shows S ON T.show_id = S.id WHERE S.movie_id = m.id AND S.time_start >= datetime('now','-7 days')))*100 
AS occupancy_rate FROM movies m
JOIN shows s
ON s.movie_id =  m.id
JOIN tickets t
ON t.show_id = s.id
GROUP BY m.id