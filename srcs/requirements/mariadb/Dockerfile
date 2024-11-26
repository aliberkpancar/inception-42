FROM debian:buster


RUN apt-get update -y && apt-get install mariadb-server -y

COPY ./conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf


COPY ./tools/init_db.sh /

RUN chmod +x /init_db.sh

EXPOSE 3306

CMD ["/init_db.sh"]