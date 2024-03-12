/*for stats*/
/*no. of tickets sold in the last week by theatre*/
SELECT
    Theatres.name AS theatre_name, 
    COUNT(*) AS tickets_sold
FROM Tickets
JOIN Shows ON Tickets.show_id = Shows.id 
JOIN Audis ON Shows.audi_id = Audis.id
JOIN Theatres ON Audis.theatre_id = Theatres.id 
WHERE Shows.time_start >= DATE('now', '-7 days')
GROUP BY Theatres.name;

/*no. of tickets sold in the last week by city*/
SELECT
    Cities.name AS city_name,
    COUNT(*) AS tickets_sold
FROM Tickets
JOIN Shows ON Tickets.show_id = Shows.id 
JOIN Audis ON Shows.audi_id = Audis.id
JOIN Theatres ON Audis.theatre_id = Theatres.id 
JOIN Cities ON Theatres.city_id = Cities.id 
WHERE Shows.time_start >= DATE('now', '-7 days')
GROUP BY Cities.name; 

/*no. of tickets sold in the last week by movie*/
SELECT
    Movies.title AS movie_title,
    COUNT(*) AS tickets_sold
FROM Tickets
JOIN Shows ON Tickets.show_id = Shows.id
JOIN Movies ON Shows.movie_id = Movies.id 
WHERE Shows.time_start >= DATE('now', '-7 days')
GROUP BY Movies.title;

/*no. of tickets sold in the last week by (start) time of the show*/
SELECT 
    CASE 
        WHEN time_start >= TIME('06:00:00') AND time_start < TIME('09:00:00') THEN '6AM-9AM'
        WHEN time_start >= TIME('09:00:00') AND time_start < TIME('12:00:00') THEN '9AM-12PM'
        WHEN time_start >= TIME('12:00:00') AND time_start < TIME('15:00:00') THEN '12PM-3PM'
        WHEN time_start >= TIME('15:00:00') AND time_start < TIME('18:00:00') THEN '3PM-6PM'
        WHEN time_start >= TIME('18:00:00') AND time_start < TIME('21:00:00') THEN '6PM-9PM'
        WHEN time_start >= TIME('21:00:00') AND time_start < TIME('24:00:00') THEN '9PM-12AM'
        -- ... Add more time ranges
        ELSE 'Other' 
    END AS time_period,
    COUNT(*) as tickets_sold
FROM Tickets
JOIN Shows ON Tickets.show_id = Shows.id
WHERE Shows.time_start >= DATE('now', '-7 days')
GROUP BY time_period;

/*total tickets sold for a movie in its run time*/
SELECT
    Movies.title,
    COUNT(*) as tickets_sold
FROM Tickets 
JOIN Shows ON Tickets.show_id = Shows.id
JOIN Movies ON Shows.movie_id = Movies.id
WHERE Movies.title = 'Baahubali: The Beginning' -- Replace with the movie title
GROUP BY Movies.title;

/*net revenue by movie*/
SELECT
    Movies.title,
    SUM(Tickets.price) AS net_revenue
FROM Tickets
JOIN Shows ON Tickets.show_id = Shows.id
JOIN Movies ON Shows.movie_id = Movies.id
GROUP BY Movies.title;




