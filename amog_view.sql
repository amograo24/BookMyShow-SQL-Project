CREATE VIEW AllTimeBoxOffice AS
SELECT
    S.movie_id,
    SUM(T.price) AS total_box_office
FROM
    Shows S
JOIN
    Tickets T ON S.id = T.show_id
JOIN
    Booking_Ticket BT ON T.id = BT.ticket_id
JOIN
    Bookings B ON BT.booking_id = B.id
WHERE
    B.status = 'booked'
GROUP BY
    S.movie_id;
    
CREATE VIEW LastMonthBoxOffice AS
SELECT
    S.movie_id,
    SUM(T.price) AS weekly_box_office
FROM
    Shows S
JOIN
    Tickets T ON S.id = T.show_id
JOIN
    Booking_Ticket BT ON T.id = BT.ticket_id
JOIN
    Bookings B ON BT.booking_id = B.id
WHERE
    B.status = 'booked' AND S.time_start >= datetime('now','-1 month')
GROUP BY
    S.movie_id;


CREATE VIEW LastWeekBoxOffice AS
SELECT
    S.movie_id,
    SUM(T.price) AS weekly_box_office
FROM
    Shows S
JOIN
    Tickets T ON S.id = T.show_id
JOIN
    Booking_Ticket BT ON T.id = BT.ticket_id
JOIN
    Bookings B ON BT.booking_id = B.id
WHERE
    B.status = 'booked' AND S.time_start >= datetime('now','-7 days')
GROUP BY
    S.movie_id;


SELECT 
    m.title as movie,
    
-- for every movie, check total number of available seats/total seats and sort by the ratio

    -- (SELECT COUNT(*) FROM Tickets T JOIN Shows S ON T.show_id = S.id WHERE S.movie_id = m.id AND T.booked = 0) AS available_seats,
    -- (SELECT COUNT(*) FROM Tickets T JOIN Shows S ON T.show_id = S.id WHERE S.movie_id = m.id) AS total_seats,
    -- (SELECT COUNT(*) FROM Tickets T JOIN Shows S ON T.show_id = S.id WHERE S.movie_id = m.id AND T.booked = 1) AS booked_seats,

    ((SELECT COUNT(*) FROM Tickets T JOIN Shows S ON T.show_id = S.id WHERE S.movie_id = m.id AND T.booked = 1)/ (SELECT COUNT(*) FROM Tickets T JOIN Shows S ON T.show_id = S.id WHERE S.movie_id = m.id))*100 as Occupancy



