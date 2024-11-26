FROM debian:buster

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./conf/my.cnf /etc/mysql/mariadb.cnf
COPY ./tools/init_db.sh /usr/local/bin/init_db.sh

RUN chmod +x /usr/local/bin/init_db.sh

# RUN --mount=type=secret,id=scrt chmod +x /conf/init_db.sh && /conf/init_db.sh && rm /conf/init_db.sh

USER mysql

EXPOSE 3306

# ENTRYPOINT ["/usr/local/bin/init_db.sh"]

# CMD ["mariadbd"]
ENTRYPOINT ["/usr/sbin/mysqld", "--defaults-file=/etc/mysql/mariadb.cnf"]
