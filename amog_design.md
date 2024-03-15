# Design Document

By Amog Rao, Mudit Surana, and Nimrat Kaur

Video overview: <URL HERE>

## Scope

In this section you should answer the following questions:

* What is the purpose of your database?
* Which people, places, things, etc. are you including in the scope of your database?
* Which people, places, things, etc. are *outside* the scope of your database?

## Functional Requirements

There are 8 major functional requirements that this database satisfies:
1) Locations - Multiple theatres are located at different citites, and these cities are located in states. Making a "States" table and a "Cities" table
    - reduces redundancy that occurs when these states and cities have to be repeated multiple times
    - makes it easier to query for theatres belonging to a state or a city (helpful in regional box office stats)

2) Users - Users refers to the customers in this case. A user can purchase tickets several times, and it's important to link these tickets to the user. A user's table
    - helps in mainting a track of all the customers
    - can be useful to understand user demographics (distribution in age groups, gender ratio, linguistic interests, etc.) that will be beneficial for an app to come up with better schemes to attract more users or increase retention rates
    - assists in linking tickets to a user and accessing a booking history assigned to that user through queries

3) Languages & Genres - Movies are made in particular langauages with a few genres in mind! A Languages table and a Genres table
    - is useful to keep associate movies to genres and languages
    - makes queries much simpler to access movies from a particular genre or language (which is very important necessity when user's prefer watching the movie in a particular langue and enjoy certain genres)

4) Theatres, Audis, and Seats - A Multiplex Theatre may have multiple Auditoriums, and each Auditorium has multiple seats! Therefore, each seat is associated to an auditorium, and each auditorium is associated to the seat. Users book a seat in an auditorium that is in a theatre. Having the theatre table, auditorium table, and seats table
    - enables queries that can get fetch auditoriums in shows and their respective seats
    - helps in keeping tack of audis in theatres, and seats in those audis
    While booking seats, it's essential to be able to query auditoriums within that theatre, and seats within that auditorium.

5) Shows - All tickets are booked for a specific show. Users essentialy book tickets for a show (which is defined by the movie, location, and timing). Having a show table
    - collates necessary details such as start time, movie, auditorium, etc. 
  
6) Tickets & Bookings - Each user essentially books a set of tickets. A booking refers to an attempt to book a set of tickets. This is the primary purpose of the database - to let users book tickets and cancel them if they want to. The Tickets and Bookings table
    - organize a list of tickets that can be bought by users
    - maintain a series of bookings that have been taken place
    - enables queries to find tickets pertaining to a show (and queries to know how many tickets are sold which in turn helps in determining the occupancy rates - another crucial metric in the film industry)
    - enables queries to find bookings of a user

    In fact, a booking can be cancelled, and the ticekts have to be displayed as available again, but this booking history of confirmations and cancellations must be stored, and this database strongly satisfies this requirement thereby retaining more data for further analysis on user booking patterns.

7) Reviews - Users should be able to write reviews on their movies along with providing ratings for the movie. Further the Reviews table
   - helps in acquring queries to find the average ratings of movies
   - it boosts user engagement (which is fundamental in such apps)

8) Box Office Statistics - This functionality is also satisfied as the total box office, along with weekly, regional, linguistic, box offices can be calculated. Occuopancy rates are also calculated similarly in this database schema. These are very important metrics in the film industry.

So in a nutshell, the user has the ability to register an account, select movie shows of prefernce, choose a seat, and book a set of tickets. Additionally these bookings may also be cancelled. The user also has the ability to obtain movies of particular genres or languages. Furthermore, the user can write reviews and provide ratings for movies, and can take a look at the box office of several movies.

Booking beverages, setting a configuration of seats within the auditorium, maintaining seperate tables for employees, curating a list of cast & crew for several films in a dedicated table, are all **out of scope for this project**.

## Representation

### Entities

In this section you should answer the following questions:

* Which entities will you choose to represent in your database?
* What attributes will those entities have?
* Why did you choose the types you did?
* Why did you choose the constraints you did?

### Relationships

In this section you should include your entity relationship diagram and describe the relationships between the entities in your database.

## Optimizations

In this section you should answer the following questions:

* Which optimizations (e.g., indexes, views) did you create? Why?

### Triggers
1) Addition of Available Seats For a New Show - Any time a new show is added, the "available seats" column is automatically updated with the number of seats present in the auditorium which is running the show.
2) Updating of Average Movie Rating - Everytime a user reviews a movie, this trigger automatically updates the "average rating" column for the movie.
3) Updation of Ticket Status & Available Seats - As soon as a booking is confirmed, the "booked" status of the ticket is set to boolean true and the "available seats" of the show is accordingly reduced (updated). Similarly, as soon as a booking is cancelled, the "booked" status of the ticket is set to boolean false and the "available seats" of the show is accordingly increased (updated).

## Limitations

In this section you should answer the following questions:

* What are the limitations of your design?
* What might your database not be able to represent very well?
