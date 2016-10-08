# Aurora Challenge Part 2

## Task: Describe how you would build an application that would monitor solar installations around the world.


As Aurora Solar grows, it is important that technologies scale as well. Aurora is collecting real time data that can be used to improve the solar industry as a whole. If systems do not scale, latency will increase to unsustainable levels. Below I lay out a database schema we could use to model our data model to keep it speedy and maintainable.

  Owner
    * id (integer)
    * name (string)
    * organization (string)
    * email (string)

  Installation
    * id (ingteger)
    * owner_id (integer, FK)
    * address (each address componenet would be a different column)

  Device
    * id (integer)
    * device_id (string, different from id)
    * active (boolean)
    * name (string)

  Channel
    * id (integer)
    * device_id (integer, FK)
    * name (string)
    * parameter (string)
    * unit (string)

  Relationships
    * One owner has many installation (could also be many-to-many, and would use join table)
    * One installation has many devices
    * One device has many channels
    * One installation has many channels

With a database like the one outlined above, we would be able to efficiently access pertinent data. We could use a PostgreSQL object-relational database to store our data. Postgres is ideal for handling large amounts of data, and other more light weight ORMDBS like SQLite would not be sufficient. One of the reasons Postgres is able to scale so well is  because it uses multiversion concurrency control. This process allows changes to be made to the database while leaving other transactions unaffected until changes are committed.

One other thing we could do to speed up database read times is index frequently accessed columns.

Three other methodologies we could use to even further speed up ourt database are:
  1. NoSQL Databases: By denormalizing our database, or making it redundat we could tailor our database to even better meet our needs.

  2. Database Sharding:
  3. Load Balancing

Task guidelines:
Every week, over 5000 new projects are created in Aurora and we would like to eventually be able to monitor these projects for our clients. You’ve gotten a chance to interact with fetching such data and build some intuition for what sort of data is useful to monitor and how the process works.

How would you design an independent application for monitoring solar installations? What type of technologies (programming languages/application frameworks/etc) would you use? What type of database would you use? What might the data structures/schema look like? And most importantly, tell us why you would make each of those decisions.

Tell us about any specific design considerations you took and why it might be important as such a monitoring system scales up. You don’t need to know the names of the technologies you would use, but its more important that you describe the properties that are important in building such an application.

Write a couple paragraphs (or bullet points) in a word document/text file for submission.