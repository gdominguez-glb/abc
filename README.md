# GreatMinds Store / CMS

[![Build Status](https://semaphoreci.com/api/v1/projects/204c885f-d98b-4320-8927-ee89532094ba/402649/badge.svg)](https://semaphoreci.com/int/greatminds)      

### Rails version

4.2.0

### Ruby version

2.2.1

### Database setup

1. Run the following commands to instate the app's configuration:

  `$ cp config/database.yml.example config/database.yml`


2. Create the database, load the schema, and initialize the app with
   seed data:

    `$ bundle exec rake db:setup`


### Spree Setup

`$ bundle exec rake db:setup`
`$ bundle exec rake db:seed`

This will ensure the default example spree data is loaded

Access the store at [here](http://localhost:3000/store)

And the Admin login [here](http://localhost:3000/store/admin)

    user: spree@example.com
    password: spree123
