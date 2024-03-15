# Design Document

By Amog Rao, Mudit Surana, and Nimrat Kaur

Video overview: <URL HERE>

## Scope

In this section you should answer the following questions:

* What is the purpose of your database?
* Which people, places, things, etc. are you including in the scope of your database?
* Which people, places, things, etc. are *outside* the scope of your database?

## Functional Requirements

In this section you should answer the following questions:

* What should a user be able to do with your database?
* What's beyond the scope of what a user should be able to do with your database?

## Representation
There are 16 tables, 8 views, 4 triggers and 5 indices. This is for optimizing the 8 Major Functionalities of our database.
### Entities

In this section you should answer the following questions:

* Which entities will you choose to represent in your database?
* What attributes will those entities have?
* Why did you choose the types you did?
* Why did you choose the constraints you did?

Our database had the following entities as listed below. The attributes for each of these entities are mentioned with their types. The explanations for our table and column constraints are given as well.
 1. States: 
     1. id PRIMARY KEY INT NOT NULL AUTOINCRMENT
     2. name VARCHAR(50) UNIQUE NOT NULL
    **Constraints**: id requires the NOT NULL constraint due to a loophole as per the sqlite documentation wherein a primary key can take on a null value. Name of the state needs to be unique and cannot be left empty.
2. Cities:
    1. id PRIMARY KEY INT NOT NULL AUTOINCRMENT
    2. name VARCHAR(75) NOT NULL
    3. state_id INTEGER NOT NULL
    **Constraints**: Each city needs to be associated to a state. In the case of a Union Territory, it will be included both as city and state. Hence, stat_id cannot be null.
3. Theatres:
    1. id VARCHAR(20) PRIMARY KEY NOT NULL
    2. name VARCHAR(255) NOT NULL
    3. city_id INTEGER NOT NULL
    4. address TEXT NOT NULL
    **Constraints**: Each theatre has to be associated to a city. Here, city is a broader term that includes towns and villages as well if need be. Every theatre must specify an address for the user's convenience. The primary key id is a VARCHAR to optimize the amount space it would take since the number of theatres is large.
4. Audis:
    1. id VARCHAR(30) PRIMARY KEY NOT NULL
    2. name VARCHAR(30) NOT NULL
    3. theatre_id VARCHAR(20) NOT NULL
    **Constraints**: Each audi has to be associated to a theatre. In case a single plex, the theatre name is stored both as an audi and a theatre. The primary key is of a bigger size as the number audis is more than the number of theatres.
5. Seats: 
    1. id VARCHAR(40) PRIMARY KEY NOT NULL
    2. name VARCHAR(5) NOT NULL
    3. theatre_id VARCHAR(30) NOT NULL
    **Constraints**: Each seat has to be associated to an audi and hence, audi_id cannot be null. The primary key is of a bigger size as the number seats is more than the number of audis.
6. Movies: 
    1. id VARCHAR(20) PRIMARY KEY NOT NULL
    2. title VARCHAR(255) NOT NULL
    3. director VARCHAR(255)
    4. avg_rating DECIMAL(4, 2)
    5. release_date DATE NOT NULL
    6. duration TIME NOT NULL
    7. certification VARCHAR(3) NOT NULL CHECK (certification IN ('U', 'U/A', 'A', 'S'))
    **Constraints**: avg_rating has a constraint of being in the range of 0 to 10 (inclusive). Certification is only given if limited types and hence, it has a check condition as well.
7. Languages:
    1. id INTEGER PRIMARY KEY AUTOINCREMENT
    2. name VARCHAR(50) UNIQUE NOT NULL
    **Constraints**: The language name has a unique constraint.
8. Genres: 
    1. id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
    2. name VARCHAR(50) UNIQUE NOT NULL
    **Constraints**: The genre name has a unique constraint.
9. Movies_Langs: 
    1. movie_id VARCHAR(20) NOT NULL
    2. lang_id INTEGER NOT NULL
    **Constraints**: Both movie_id and lang_id are passed as a primary key for denoting the many-to-many relationship.
10. Movies_Genres:
    1. movie_id VARCHAR(20) NOT NULL
    2. genre_id INTEGER NOT NULL
    **Constraints**: Both movie_id and genre_id are passed as a primary key for denoting the many-to-many relationship.
11. Reviews:
    1. id VARCHAR(40) PRIMARY KEY NOT NULL
    2. customer_id VARCHAR(30)
    3. movie_id VARCHAR(20) NOT NULL
    4. rating DECIMAL(4, 2) NOT NULL,
    5. time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  
    6. comment TEXT,
    **Constraints**: The rating is constrained to be in a range between 0 to 10 (inclusive). It cna be noted that customer_id may be null to allow anonymous reviews.
12. Customers:
    1. id VARCHAR(30) PRIMARY KEY NOT NULL
    2. name VARCHAR(255) NOT NULL
    3. email VARCHAR(255) UNIQUE NOT NULL
    4. phone_number VARCHAR(14) UNIQUE NOT NULL
    5. date_of_birth DATE NOT NULL
    6. date_of_joining DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    7. gender CHAR(1) NOT NULL
    **Constraints**: email has a constraint of containing the character '@' to ensure that an email has been passed. It is also uniqye like the phone_number. phone_number has constraint of starting with '+' to enter the country code and only allows numeric characters. date_of_joining is by deafult set to the current time.
13. Shows: 
    1. id VARCHAR(40) PRIMARY KEY NOT NULL
    2. movie_id VARCHAR(20) NOT NULL
    3. audi_id VARCHAR(30) NOT NULL
    4. time_start DATETIME NOT NULL
    5. time_end DATETIME NOT NULL
    6. available_seats INTEGER NOT NULL DEFAULT 0
    **Constraints**: time_end has to be greater than time_start and the available seats can only be a non-negative integer
    14. Tickets: 
    1. id VARCHAR(40) PRIMARY KEY NOT NULL
    2. show_id VARCHAR(40) NOT NULL
    3. seat_id INTEGER NOT NULL
    4. booked BOOLEAN DEFAULT FALSE NOT NULL
    5. price DECIMAL(10, 2) NOT NULL CHECK(price >= 0)
    **Constraints**: The price can only take in a non-negative numeric value.
15. Bookings:
    1. id VARCHAR(40) PRIMARY KEY
    2. customer_id VARCHAR(30) NOT NULL,
    3. status VARCHAR(20) NOT NULL CHECK (status IN ('booked', 'cancelled', 'held', 'dropped))
    4. booking_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    **Constraints**: The status of a booking can only be from a certain set and hence, it has a check condition.
16. Bookings_Tickets: 
    1. booking_id VARCHAR(40) NOT NULL
    2. ticket_id VARCHAR(40) NOT NULL
    **Constraints**: Both booking_id and ticket_id are passed as a primary key for denoting the many-to-many relationship.

### Relationships

In this section you should include your entity relationship diagram and describe the relationships between the entities in your database.

* **Cities and States (many-to-one)**: Many cities can belong to the same state.
* **Theatres and Cities (many-to-one)**: Many theatres can belong to the same city.
* **Audis and Theatres (many-to-one)**: Many audis can belong to the same theatre.
* **Seats and Audis (many-to-one)**: Many seats can belong to the same audi.
* **Shows and Audis (many-to-one)**: Many shows can be in the same audi.
* **Tickets and Shows (many-to-one)**: Many tickets can be generated for the same show.
* **Tickets and Seats (many-to-one)**: Many tickets can be generated for the same seat.
* **Shows and Movies (many-to-one)**: Many shows can be showing the same movie.
* **Reviews and Customers (many-to-one)**: Many reviews can be written by the same customer.
* **Reviews and Movies (many-to-one)**: Many reviews can written for the same movie.
* **Bookings and Customers (many-to-one)**: Many bookings can be made by the same customer.
* **Bookings and Tickets (many-to-many)**: Many bookings can be made for the same ticket as a booking can be cancelled as well. One booking can be made for multiple tickets at once.
* **Movies and Genres (many-to-many)**: Many movies can belong to the same genre. One movie can have multiple genres.
* **Movies and Languages (many-to-many)**: Many movies can be made in the same language. One movie can be made in multiple languages.


## Optimizations

In this section you should answer the following questions:

* Which optimizations (e.g., indexes, views) did you create? Why?

### Indexes
* Covering index on show_id and available_seats in Shows.
* Covering index on show_id and audi_id in Shows.
* Covering index on ticket_id and seat_id in Tickets.
* Covering index on ticket_id and booked in Tickets.
* Covering index on ticket_id and price in Tickets.
These triggers are only on Shows and Tickets. Entries to these tables are made only once week and hence, slowing down of the insertion or updation process is not of concern. These triggers would boost the speed for the user.

## Limitations
* It is entirely user-centric and does not keep track of the owners of the theatres.
* Since it doesn't keep track of cast and crew, the database cannot be used get recommendations based on these.
* It does not account for different formats of theatres such as outdoor movie viewings which don't have allocated seats.
* Our database is limited only to movie shows unlike BookMyShow which also caters to concerts, fests and more.
* The configuration of seats cannot be reperesented.
* It does not facilitate purchase of food and beverages.

