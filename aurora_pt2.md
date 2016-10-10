# Aurora Challenge Part 2

#### Task: Describe how you would build an application that would monitor solar installations around the world.

As Aurora Solar grows, it is important that technologies scale as well. Aurora is collecting real time data that can be used to improve the solar industry as a whole. If systems do not scale, latency will increase to unsustainable levels. Below I lay out a database schema we could use to model our data to keep it speedy and maintainable.

  1. Owner
    * id (integer)
    * name (string)
    * organization (string)
    * email (string)

  2. Installation
    * id (integer)
    * owner_id (integer, FK)

  3. Device
    * id (integer)
    * installation_id (integer, FK)
    * device_id (string, different from id)
    * active (boolean)
    * name (string)

  4. Channel
    * id (integer)
    * device_id (integer, FK)
    * name (string)
    * parameter (string)
    * unit (string)

  5. Relationships
    * One owner has many installation (could also be many-to-many, and would use join table)
    * One installation has many devices
    * One device has many channels
    * One installation has many channels

With a database like the one outlined above, we would be able to efficiently access pertinent data. We could use a PostgreSQL object-relational database to store our data. Postgres is ideal for handling large amounts of data, and other more lightweight ORMDBS like SQLite would not be sufficient. One of the reasons Postgres is able to scale so well is  because it uses multiversion concurrency control. This process allows changes to be made to the database while leaving other transactions unaffected until changes are committed.

Three other methodologies we could implement to even further speed up our database are:

  1. **Index Frequently Accessed Columns:** An index is a copy of a column that can be searched efficiently because each cell is a direct reference to the location in memory and has a link to the corresponding row. By indexing frequently accessed columns, we can speed up both reads and writes. Because, writes occur multiple times a day in our monitoring system, this could make a significant difference.

  2. **NoSQL Databases:** By denormalizing our database, or making our data redundant we could tailor our database to even better meet our needs. Certain popular NoSQL databases we could use include MongoDB, a document based storage system, and Redis, a key value storage system.

  3. **Database Sharding:** Sharding our data or partitioning it between multiple servers could help balance the significant load and increase latency. However, sharding introduces significant complexity and makes altering our schema much more difficult.

Because Aurora is still growing quickly, it is important that all the technologies used are adaptable and optimize for developer time. Some frameworks that meet these needs are Rails and Django for the backend and AngularJS or ReactJS for the front end. While in the future, Aurora might want to switch to more computationally efficient stacks, for now it is more important that technologies are flexible and easy to iterate on.