CREATE TABLE IF NOT EXISTS movies(

);
CREATE TABLE IF NOT EXISTS theatres(
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS audis(
    "id" INTEGER,
    "name" TEXT,
    "theatre_id" INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("theatre_id") REFERENCES "theatres"("id")
);
CREATE TABLE IF NOT EXISTS seats(

);
CREATE TABLE IF NOT EXISTS shows(

);
CREATE TABLE IF NOT EXISTS tickets(

);
CREATE VIEW IF NOT EXISTS prices AS (

);
