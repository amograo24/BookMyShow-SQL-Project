CREATE VIEW WeeklyOccupancyRates AS
SELECT m.title, ((SELECT COUNT(*) FROM Tickets T JOIN Shows S ON T.show_id = S.id WHERE S.movie_id = m.id AND T.booked = 1 AND S.time_start >= datetime('now','-7 days'))/ (SELECT COUNT(*) FROM Tickets T JOIN Shows S ON T.show_id = S.id WHERE S.movie_id = m.id AND S.time_start >= datetime('now','-7 days')))*100 
AS occupancy_rate FROM movies m
JOIN shows s
ON s.movie_id =  m.id
JOIN tickets t
ON t.show_id = s.id
GROUP BY m.id

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

