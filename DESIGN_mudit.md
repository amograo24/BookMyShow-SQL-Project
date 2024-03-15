# Design Document

By Amog Rao, Mudit Surana, and Nimrat Kaur

Video overview: <URL HERE>

## Scope

In this section you should answer the following questions:

* What is the purpose of your database?
    The primary purpose of this database is to facilitate a movie ticket booking system. Here's what it aims to achieve:
        Manage movie listings: Store information about movies (title, release date, genre, ratings, etc.).
        Track showtimes and venues: Record show timings, theatres, auditoriums, and available seating.
        Handle customer bookings: Manage customer information, ticket reservations, and booking confirmations.
        Support basic reporting: Provide insights into sales trends, movie popularity, and occupancy rates.
* Which people, places, things, etc. are you including in the scope of your database?
    In Scope:
        People:
            Customers (name, email, contact information, booking history)
        Places:
            States
            Cities
            Theatres
            Auditoriums (within Theatres)
        Things:
            Movies
            Movie Genres
            Movie Languages
            Shows (screenings of a specific movie, at a specific time, in a specific auditorium)
            Seats (individual seats within an auditorium)
            Tickets
            Bookings (linking customers to tickets with a status)
            Reviews (customer ratings for movies)
* Which people, places, things, etc. are *outside* the scope of your database?
    Financials: No detailed accounting, payment gateway integration, or complex discount/promotional pricing mechanisms.
    Detailed Inventory: No tracking of concessions (food/beverages) or other merchandise sales.
    User Authentication: While the Customers table stores basic information, it likely doesn't manage passwords or complex user permissions.
    External Systems: The database doesn't seem to handle interactions with third-party services (e.g., map providers for theatre locations).

## Functional Requirements

In this section you should answer the following questions:

* What should a user be able to do with your database?
* What's beyond the scope of what a user should be able to do with your database?\

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
Views Created

WeeklyOccupancyRates:
    Purpose: Calculates the percentage of seats occupied for each movie over the past week.
    Optimization: Provides a pre-calculated metric for analyzing the popularity of movies and identifying shows with high or low demand.

AllTimeBoxOffice, LastMonthBoxOffice, LastWeekBoxOffice:
    Purpose: Calculates total box office revenue (money generated from ticket sales) for each movie, grouped by different time periods (all-time, last month, last week).
    Optimization: Aggregates sales data, making it easier to track revenue trends, identify top-performing movies, and potentially make decisions about future movie programming.

DailyTicketsSoldPerPeriod:
    Purpose: Breaks down ticket sales into time periods (e.g., 6AM-9AM, 9AM-12PM).
    Optimization: Helps analyze peak sales times, potentially leading to staffing or show-time adjustments for optimal resource allocation.

WeeklyTicketsByTheatre, WeeklyTicketsByCity, WeeklyTicketsByMovie:
    Purpose: Calculates the number of tickets sold for the past week, grouped by theatre, city, and movie, respectively.
    Optimization: Provides insights into location-based popularity, which shows perform well in specific areas, and potential theatre performance comparisons.

Why Use Views for Optimization
    Pre-Calculated Data: Views store the results of potentially complex aggregations and joins.  This avoids recalculating these metrics every time you need them in a report.
    Simplified Queries: Views can hide the complexity of the underlying SQL, making it easier for users to query for the summarized data they need.
    Readability: Views give meaningful names to calculated metrics, making it clear what the data represents.

## Limitations

In this section you should answer the following questions:

* What are the limitations of your design?
* What might your database not be able to represent very well?
