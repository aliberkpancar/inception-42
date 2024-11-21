FROM debian:11

RUN apt-get update && \
	apt-get install -y nginx openssl && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl /etc/nginx/conf.d /etc/nginx/sites-enabled /run/nginx

COPY ./conf/default /etc/nginx/sites-enabled/default
COPY ./conf/default /etc/nginx/default
COPY ./tools/nginx.sh /var/www/nginx.sh

RUN chmod +x /var/www/nginx.sh

EXPOSE 443

ENTRYPOINT ["/var/www/nginx.sh"]

CMD ["nginx", "-g", "daemon off;"]