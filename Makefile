
TAG=erochest/omeka
NAME=omeka

build:
	docker build -t ${TAG} .

run: build
	docker run -d -p 80:80 --name ${NAME} ${TAG}

stop:
	docker stop ${NAME}

start: run
	docker start ${NAME}

clean: stop
	docker rm ${NAME}

distclean: clean
	docker rmi ${TAG}

status:
	docker ps

details:
	docker inspect ${NAME}

