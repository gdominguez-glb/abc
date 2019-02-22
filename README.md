## Dependencies
### Docker
Install Docker CE following these steps [https://docs.docker.com/install/linux/docker-ce/ubuntu/](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

If you are using Docker in Linux, make sure that you can manage docker with a non-root user. To do so, follow these steps: [https://docs.docker.com/install/linux/linux-postinstall/](https://docs.docker.com/install/linux/linux-postinstall/)

Make sure that docker is up and running with the following command:
```
docker -v
```

You should see some output telling the current version. This is an example:
```
Docker version 18.06.1-ce, build e68fc7a
```

### Docker Compose
Install docker-compose following these steps [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

Make sure that docker-compose is up and running with the following command:
```
docker-compose -v
```

You should see some output telling the current version. This is an example:
```
docker-compose version 1.23.2, build 1110ad01
```

### Docker Machine

Install docker-machine only if you are on MacOS or Windows 10 following these steps: [https://docs.docker.com/machine/install-machine/](https://docs.docker.com/machine/install-machine/)

### GitHub
Set your shh access on Github with the following tutorial: [https://help.github.com/articles/connecting-to-github-with-ssh/](https://help.github.com/articles/connecting-to-github-with-ssh/)

## Environment configuration

### Source Code

Get the GreatMinds source code
#### SSH
```
git clone git@github.com:enelsongm/greatminds.git
```
#### HTTPS
```
git clone https://github.com/greatmindsorg/greatminds.git
```

### Building the project

Build the project with Docker
```
$ cd greatminds/
$ docker-compose build
```

Run the following commands to generate the app's local configuration:
```
$ cp config/database.yml.example config/database.yml
$ cp config/application.yml.example config/application.yml
```

Add this to the `config/database.yml` on the default configuration

```
user: postgres
host: db
Password:
```

### Database Setup

```
$ sudo docker-compose run greatminds rake db:create
$ sudo docker-compose run -T greatminds rake db:migrate RAILS_ENV=test
```
We need the DB to be running in order to import a DB:
```
$ sudo docker-compose up
```
Now we are going to import a development database. Ask a developer for a dump of that database and put that into a file called database_export.pgsql in the root folder of the project. Then, with the container up, open another terminal window and run:
```
$ sudo docker container exec greatminds_db_1 /bin/bash -c "psql -U postgres GreatMinds_development < /home/database_export.pgsql"
```

### Run the app
Every time you want to make the app available, you need to run:
```
$ sudo docker-compose up
```
Then open a browser and type this url: [http://localhost:3000](http://localhost:3000)
### Run the tests
```
$ sudo docker-compose run -T greatminds bundle exec guard
```
### Deploy
```
$ sudo docker-compose run greatminds bundle exec cap staging deploy
$ sudo docker-compose run greatminds bundle exec cap production deploy
```
