FROM tutum/apache-php:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes install imagemagick git
RUN DEBIAN_FRONTEND=noninteractive apt-get clean

RUN rm -fr /app/* && git clone --branch master --recursive https://github.com/omeka/Omeka.git
RUN chmod -R a+rwx /app/Omeka/files
RUN a2enmod rewrite && service apache2 restart

COPY ./files/config.ini /app/Omeka/application/config/config.ini
COPY ./files/db.ini /app/Omeka/db.ini
COPY ./files/htaccess /app/Omeka/.htaccess
COPY ./files/tests.ini /app/Omeka/application/tests/config.ini
COPY ./files/000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80
WORKDIR /app
ADD . /app
CMD ["/run.sh"]
