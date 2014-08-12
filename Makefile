
OMEKA_TAG=erochest/omeka
OMEKA_NAME=omeka

MYSQL_TAG=mysql
MYSQL_NAME=mysql

MYSQL_ROOT_PASS=rootpass

build:
	docker build -t ${OMEKA_TAG} .

run: build
	docker run -d --name ${MYSQL_NAME} -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASS} -d mysql
	docker run -d -p 80:80 --link ${MYSQL_NAME}:mysql --name ${OMEKA_NAME} ${OMEKA_TAG}
	make copysql

copysql:
	docker run -v /vagrant/working:/mnt mysql cp /mnt/files/create.sql /tmp/

mysql:
	docker run -it --link ${MYSQL_NAME}:mysql --rm mysql sh -c 'exec mysql -h"$$MYSQL_PORT_3306_TCP_ADDR" -P"$$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'

createdb:
	docker run -it --link ${MYSQL_NAME}:mysql --rm mysql sh -c 'exec mysql -h"$$MYSQL_PORT_3306_TCP_ADDR" -P"$$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$$MYSQL_ENV_MYSQL_ROOT_PASSWORD" < /tmp/create.sql'

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

