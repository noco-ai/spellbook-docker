FROM mariadb:latest
RUN apt-get update && apt-get install -y openssl curl && apt-get clean
COPY mariadb/spellbook.sql /docker-entrypoint-initdb.d/0-spellbook.sql
COPY mariadb/db-init.sh /docker-entrypoint-initdb.d/1-db-init.sh
RUN chmod +x /docker-entrypoint-initdb.d/1-db-init.sh
RUN mkdir /credentials
RUN chown mysql:mysql credentials