CREATE VIEW DailyTicketsSoldPerPeriod AS
SELECT 
    DATE(Shows.time_start) AS sale_date,
    CASE 
        WHEN HOUR(Shows.time_start) >= 6 AND HOUR(Shows.time_start) < 9 THEN '6AM-9AM'
        WHEN HOUR(Shows.time_start) >= 9 AND HOUR(Shows.time_start) < 12 THEN '9AM-12PM'
        -- ... Add more cases for further periods
        ELSE 'Other' 
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
WHERE Shows.time_start >= NOW() - INTERVAL 1 WEEK 
  AND Tickets.booked = TRUE 
GROUP BY Theatres.name 
ORDER BY tickets_sold DESC; 


CREATE VIEW WeeklyTicketsByCity AS
SELECT 
   Cities.name AS city_name,
   COUNT(*) AS tickets_sold
FROM Shows
JOIN Tickets ON Shows.id = Tickets.show_id
JOIN Audis ON Shows.audi_id = Audis.id
JOIN Theatres ON Audis.theatre_id = Theatres.id
JOIN Cities ON Theatres.city_id = Cities.id 
WHERE Shows.time_start >= NOW() - INTERVAL 1 WEEK 
  AND Tickets.booked = TRUE 
GROUP BY Cities.name
ORDER BY tickets_sold DESC;


CREATE VIEW WeeklyTicketsByMovie AS
SELECT 
   Movies.title AS movie_title,
   COUNT(*) AS tickets_sold
FROM Shows
JOIN Tickets ON Shows.id = Tickets.show_id
JOIN Movies ON Shows.movie_id = Movies.id
WHERE Shows.time_start >= NOW() - INTERVAL 1 WEEK 
  AND Tickets.booked = TRUE 
GROUP BY Movies.title
ORDER BY tickets_sold DESC;

