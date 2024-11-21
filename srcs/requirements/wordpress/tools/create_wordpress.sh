#!/bin/bash

# Check if WordPress is already installed
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --path=/var/www/html --allow-root

    echo "Creating wp-config.php..."
    wp config create \
        --dbname=${WORDPRESS_DB_NAME} \
        --dbuser=${WORDPRESS_DB_USER} \
        --dbpass=${WORDPRESS_DB_PASSWORD} \
        --dbhost=${WORDPRESS_DB_HOST} \
        --path=/var/www/html \
        --allow-root

    echo "Installing WordPress..."
    wp core install \
        --url=${DOMAIN_NAME} \
        --title="My WordPress Site" \
        --admin_user=${WORDPRESS_ADMIN_USER} \
        --admin_password=${WORDPRESS_ADMIN_PASSWORD} \
        --admin_email=${WORDPRESS_ADMIN_EMAIL} \
        --path=/var/www/html \
        --allow-root
fi

echo "Starting PHP-FPM..."
exec "$@"
