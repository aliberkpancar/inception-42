#!/bin/sh

export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)
export MYSQL_USER=$(cat /run/secrets/mysql_user)
export MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)
export MYSQL_DATABASE=$(cat /run/secrets/mysql_database)


if [ -f ./wp-config.php ]; then
  echo "WordPress already downloaded"
  exec "$@"
fi

if [ -d ./wp-admin ] || [ -d ./wp-content ] || [ -d ./wp-includes ]; then
  echo "WordPress files already exist. Skipping extraction."
  rm -rf ./wp-admin ./wp-content ./wp-includes
fi

echo "Downloading WordPress..."
wget -q http://wordpress.org/latest.tar.gz
echo "Extracting WordPress..."
tar xfz latest.tar.gz
mv wordpress/* .

rm -rf latest.tar.gz
rm -rf wordpress

if ! command -v wp &> /dev/null; then
  echo "WP-CLI not found. Installing..."
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
  php /usr/local/bin/wp --info
  if [ $? -ne 0 ]; then
    echo "Error: WP-CLI installation failed."
    exit 1
  fi
fi

wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb:3306 --skip-check --allow-root

wp core install --url="http://localhost" --title="My WordPress Site" --admin_user="admin" --admin_password=$MYSQL_ROOT_PASSWORD --admin_email="admin@example.com" --allow-root

wp option update blogname "My WordPress Site" --allow-root
wp option update blogdescription "Just another WordPress site" --allow-root


exec "$@"
