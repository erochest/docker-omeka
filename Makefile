
NOCACHE=

OMEKA_TAG=erochest/omeka
OMEKA_NAME=omeka

MYSQL_TAG=mysql
MYSQL_NAME=mysql

MYSQL_ROOT_PASS=rootpass

build:
	docker build ${NOCACHE} -t ${OMEKA_TAG} .

run:
	docker run -d --name ${MYSQL_NAME} -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASS} -d mysql
	docker run -d -p 80:80 --link ${MYSQL_NAME}:mysql --name ${OMEKA_NAME} ${OMEKA_TAG}
	make copysql

mysql:
	docker run -it --link ${MYSQL_NAME}:mysql --rm mysql sh -c 'exec mysql -h"$$MYSQL_PORT_3306_TCP_ADDR" -P"$$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'

createdb:
	mysql -h`docker inspect ${MYSQL_NAME} | grep IPAddress | sed -e 's/.*: "\(.*\)",/\1/'` -uroot -p${MYSQL_ROOT_PASS} < files/create.sql

boot2db:
	docker run -it --link mysql:mysql --rm mysql sh -c 'exec mysql -h"$$MYSQL_PORT_3306_TCP_ADDR" -P"$$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -e"'"CREATE USER 'omeka'@'localhost' IDENTIFIED BY 'omeka';"'"'
	docker run -it --link mysql:mysql --rm mysql sh -c 'exec mysql -h"$$MYSQL_PORT_3306_TCP_ADDR" -P"$$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -e"'"CREATE USER 'omeka'@'%' IDENTIFIED BY 'omeka';"'"'
	docker run -it --link mysql:mysql --rm mysql sh -c 'exec mysql -h"$$MYSQL_PORT_3306_TCP_ADDR" -P"$$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -e"'"CREATE DATABASE omeka CHARACTER SET='utf8' COLLATE='utf8_unicode_ci';"'"'
	docker run -it --link mysql:mysql --rm mysql sh -c 'exec mysql -h"$$MYSQL_PORT_3306_TCP_ADDR" -P"$$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -e"'"GRANT ALL PRIVILEGES ON omeka.* TO 'omeka'@'localhost';"'"'
	docker run -it --link mysql:mysql --rm mysql sh -c 'exec mysql -h"$$MYSQL_PORT_3306_TCP_ADDR" -P"$$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -e"'"GRANT ALL PRIVILEGES ON omeka.* TO 'omeka'@'%';"'"'

pull:
	docker pull ${MYSQL_TAG}
	docker pull ${OMEKA_TAG}

stop:
	docker stop ${OMEKA_NAME}
	docker stop ${MYSQL_NAME}

start: run
	docker start ${OMEKA_NAME}

clean: stop
	docker rm ${OMEKA_NAME}
	docker rm ${MYSQL_NAME}

distclean: clean
	docker rmi ${OMEKA_TAG}

status:
	docker ps

details:
	docker inspect ${OMEKA_NAME}

rebuild:
	make distclean
	make build
	make start
	sleep 5
	make createdb

go:
	make pull
	make start
	sleep 5
	make createdb

boot2go:
	make pull
	make start
	sleep 5
	make boot2db

.PHONY: build run copysql mysql createdb stop start clean distclean status details rebuild pull go boot2go boot2db
