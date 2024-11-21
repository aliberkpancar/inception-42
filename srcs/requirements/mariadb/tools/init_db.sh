#!/bin/bash

# Validate environment variables
: "${DB_NAME:?DB_NAME is required}"
: "${DB_USER:?DB_USER is required}"
: "${DB_PASSWORD:?DB_PASSWORD is required}"
: "${MYSQL_DB_PASSWORD:?MYSQL_DB_PASSWORD is required}"

# Initialize MySQL data directory if not initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing MySQL data directory..."
  mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in the background
mysqld_safe --datadir=/var/lib/mysql &

# Wait for MariaDB to start
sleep 5

# Run initialization SQL
cat <<EOF | mysql
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_DB_PASSWORD}';
EOF

echo "Initialization complete."

# Prevent script deletion (for debugging purposes)
# rm -rf /var/www/init_db.sh
