# Design Document

By Amog Rao, Mudit Surana, and Nimrat Kaur

Video overview: <URL HERE>

## Scope

In this section you should answer the following questions:

* What is the purpose of your database?
* Which people, places, things, etc. are you including in the scope of your database?
* Which people, places, things, etc. are *outside* the scope of your database?

## Functional Requirements



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
