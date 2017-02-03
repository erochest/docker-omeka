FROM tutum/apache-php:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes install imagemagick git
RUN DEBIAN_FRONTEND=noninteractive apt-get clean

RUN rm -fr /app/* && git clone --branch db-envvars --recursive https://github.com/erochest/Omeka.git /app
RUN cd /app && git checkout db-envvars
RUN chmod -R a+rwx /app/files
RUN a2enmod rewrite && service apache2 restart

COPY ./files/config.ini /app/application/config/config.ini
COPY ./files/db.ini /app/db.ini
COPY ./files/htaccess /app/.htaccess
COPY ./files/tests.ini /app/application/tests/config.ini
COPY ./files/000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80
WORKDIR /app
ADD . /app
CMD ["/run.sh"]
