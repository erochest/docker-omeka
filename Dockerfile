FROM tutum/apache-php:latest

RUN rm -fr /app && git clone --branch db-envvars --recursive https://github.com/erochest/Omeka.git /app
COPY ./files/config.ini /app/application/config/config.ini
COPY ./files/db.ini /app/db.ini
COPY ./files/htaccess /app/.htaccess
COPY ./files/tests.ini /app/application/tests/config.ini

EXPOSE 80
WORKDIR /app
ADD . /app
CMD ["/run.sh"]
