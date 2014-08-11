FROM tutum/apache-php:latest
RUN rm -fr /app && git clone --branch db-envvars --recursive https://github.com/erochest/Omeka.git /app
EXPOSE 80
WORKDIR /app
ADD . /app
CMD ["/run.sh"]
