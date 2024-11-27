#!/bin/bash

service mysql start

sleep 1

export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)
export MYSQL_USER=$(cat /run/secrets/mysql_user)
export MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)
export MYSQL_DATABASE=$(cat /run/secrets/mysql_database)

mysql -u root -p$MYSQL_ROOT_PASSWORD <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF

kill $(cat /var/run/mysqld/mysqld.pid)

mysqld