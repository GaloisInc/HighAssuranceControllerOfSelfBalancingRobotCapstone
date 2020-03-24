# otis-tcp

Receives data from arduino using otis-arduino code through TCP, and stores in SQL database.


Requires diesel_cli, mysql

1. mysql database has to be setup for diesel migration
2. .env file used to store mysql connection with diesel is not shown
2. Arduino IP address hardcoded in main if change req.
