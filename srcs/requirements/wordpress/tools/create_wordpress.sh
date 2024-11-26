#!/bin/sh

export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)
export MYSQL_USER=$(cat /run/secrets/mysql_user)
export MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)
export MYSQL_DATABASE=$(cat /run/secrets/mysql_database)

# Check if wp-config.php exists, if not, proceed with the installation
if [ -f ./wp-config.php ]; then
  echo "WordPress already downloaded"
else
  # Download and extract WordPress
  wget http://wordpress.org/latest.tar.gz
  tar xfz latest.tar.gz
  mv wordpress/* .
  rm -rf latest.tar.gz
  rm -rf wordpress

  # Install WP-CLI if it's not available
  if ! command -v wp &> /dev/null; then
    echo "WP-CLI not found. Installing..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
  fi

  # Configure WordPress using WP-CLI with MySQL credentials
  wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb:3306 --skip-check

  # Install WordPress (the URL, title, and admin user will be generic)
  wp core install --url="http://localhost" --title="My WordPress Site" --admin_user="admin" --admin_password=$MYSQL_ROOT_PASSWORD --admin_email="admin@example.com"

  # Set additional WP options (like blogname, blogdescription)
  wp option update blogname "My WordPress Site"
  wp option update blogdescription "Just another WordPress site"
fi

# Execute the passed command (allowing for custom command execution)
exec "$@"
