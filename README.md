# GreatMinds Store / CMS

[![Build Status](https://semaphoreci.com/api/v1/projects/204c885f-d98b-4320-8927-ee89532094ba/402649/badge.svg)](https://semaphoreci.com/int/greatminds)

[![Code Climate](https://codeclimate.com/repos/5537ca5be30ba00665000ce2/badges/07406c2e96832b7012b3/gpa.svg)](https://codeclimate.com/repos/5537ca5be30ba00665000ce2/feed)

### Rails version

4.2.0

### Ruby version

2.1.6

### Elasticsearch

```
$ brew install elasticsearch
$ elasticsearch
```

### Redis

```
$ brew install redis
$ redis-server
```

### Database setup

1. Run the following commands to instate the app's configuration:

  `$ cp config/database.yml.example config/database.yml`

2. set application.yml for environment variables

  `$ cp config/application.yml.example config/application.yml`

3. Create the database, load the schema, and initialize the app with
   seed data:

    `$ bundle exec rake db:create && bundle exec rake db:migrate && bundle exec rake db:seed`

### Init Site Pages

`$ bundle exec rake pages:reset`

This will ensure the default example spree data is loaded

Access the store at [here](http://localhost:3000/store)

And the Admin login [here](http://localhost:3000/store/admin)

    user: web.admin@greatminds.net
    password: intridea4gm

### Start sidekiq

`$ bundle exec sidekiq`

### QA / Staging

Visit QA http://gm-qa.intridea.com/store/admin

Visit Staging http://gm-staging.intridea.com/store/admin

Login with

    un: greatminds
    pw: intridea4gm

### Run tests with guard

`$ bundle exec guard`
