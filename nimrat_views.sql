CREATE VIEW occp_rate AS
SELECT m.title, ___ AS occupancy_rate FROM movies m
JOIN shows s
ON s.movie_id =  m.id
JOIN tickets t
ON t.show_id = s.id
GROUP BY m.id