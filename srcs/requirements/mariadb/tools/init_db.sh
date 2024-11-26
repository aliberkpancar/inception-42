#!/bin/sh

# Export environment variables
export $(grep -v '^#' /run/secrets/* | xargs)

# Start MariaDB service
if ! service mariadb start; then
    echo "Failed to start MariaDB service"
    exit 1
fi

# Database setup
if ! mariadb -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"; then
    echo "Failed to create database ${MYSQL_DATABASE}"
    exit 1
fi

# User setup
if ! mariadb -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"; then
    echo "Failed to create user ${MYSQL_USER}"
    exit 1
fi

# Grant privileges
if ! mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"; then
    echo "Failed to grant privileges to ${MYSQL_USER}"
    exit 1
fi

# Flush privileges
if ! mariadb -e "FLUSH PRIVILEGES;"; then
    echo "Failed to flush privileges"
    exit 1
fi

# Stop MariaDB service (optional)
if ! service mariadb stop; then
    echo "Failed to stop MariaDB service"
    exit 1
fi

# Run MariaDB in the foreground (if applicable)
exec mysqld_safe
