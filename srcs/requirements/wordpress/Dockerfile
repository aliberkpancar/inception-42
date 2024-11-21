FROM debian:11

RUN apt update && apt upgrade -y && apt install -y wget curl lsb-release gnupg \
    && curl -sSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /usr/share/keyrings/php.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && apt update && apt install -y wget curl \
       php8.2 php8.2-cli php8.2-fpm php8.2-cgi php8.2-mysql php8.2-pdo \
       php8.2-gd php8.2-mbstring php8.2-redis \
       redis \
    && rm -rf /var/lib/apt/lists/*

	
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/

RUN mkdir -p /run/php /var/www/html

COPY ./tools/create_wordpress.sh /usr/local/bin/create_wordpress.sh

RUN chmod +x /usr/local/bin/create_wordpress.sh

WORKDIR /var/www/html/

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/create_wordpress.sh"]

CMD ["/usr/sbin/php-fpm8.2", "-F"]