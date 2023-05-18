FROM mysql:5.7

ENV TZ=Asia/Shanghai \
    MYSQL_ROOT_PASSWORD=root \
    MYSQL_USER=admin \
    MYSQL_PASSWORD=password \
    MYSQL_DATABASE=hive

LABEL auther="guox(guox@goodrain.com)"

VOLUME ["/var/lib/mysql", "/var/log/mysql"]

EXPOSE 3306

COPY ./*.sql /docker-entrypoint-initdb.d/
COPY mysqld.cnf /etc/mysql/conf.d/mysqld.cnf
RUN chmod 644 /etc/mysql/conf.d/mysqld.cnf