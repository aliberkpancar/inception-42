FROM debian:buster

# Install MariaDB server
RUN apt-get update && apt-get install -y mariadb-server && apt-get clean

# Copy configuration and scripts
COPY ./conf/my.cnf /etc/mysql/my.cnf
COPY ./tools/init_db.sh /var/www/init_db.sh

# Set proper permissions
RUN chmod +x /var/www/init_db.sh

# Expose MySQL port
EXPOSE 3306

# Start the script and database server
CMD ["/bin/bash", "-c", "/var/www/init_db.sh && mysqld_safe --datadir=/var/lib/mysql"]
