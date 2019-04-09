FROM ubuntu:latest

## Make sure Ubuntu is up-to-date
RUN apt-get update
RUN apt-get -y upgrade

# Install Apache, mod-perl, and a bunch of perl libraries (and ping)
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 libapache2-mod-perl2 make curl git gcc iputils-ping

# "build" the app... aka copy over the scripts and confs
RUN mkdir /var/www/cgiapp
COPY ./myapp.cgi /var/www/cgiapp
COPY ./cgilog.txt /var/www/cgiapp
COPY ./index.html /var/www/cgiapp
COPY ./perlcgi.conf /etc/apache2/sites-available
COPY ./ports.conf /etc/apache2/ports.conf

# Enable apache mods, disable sites etc
RUN a2enmod perl
RUN a2enmod rewrite
RUN a2enmod cgi.load
RUN a2enmod cgid.load
RUN a2ensite perlcgi.conf
RUN a2dissite 000-default.conf


RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxml-libxml-perl libxml-twig-perl libxml-simple-perl libwww-mechanize-perl libfile-slurp-perl libgetopt-long-descriptive-perl liblwp-useragent-determined-perl libdata-printer-perl libtest-strict-perl cpanminus

EXPOSE 80

RUN service apache2 start

# To not "kill" the container
CMD ["/usr/sbin/apachectl","-DFOREGROUND"] 