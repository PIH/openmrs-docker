FROM ubuntu:16.04

MAINTAINER Michael Seaton <mseaton@pih.org>

# Install packages

RUN apt-get update
RUN apt-get -y install openjdk-8-jdk
RUN apt-get -y install tomcat7-user
RUN apt-get -y install postgresql
RUN apt-get -y install wget
RUN apt-get -y install gzip

# Configure database

USER postgres

RUN service postgresql start &&\
 	createuser -SDR dhis &&\
 	psql -c "ALTER USER dhis PASSWORD 'dhis';" &&\
 	createdb -O dhis dhis2

RUN echo "host all  all    0.0.0.0/0  md5" >> $(find /etc/postgresql -name pg_hba.conf)
RUN echo "listen_addresses='*'" >> $(find /etc/postgresql -name postgresql.conf)

VOLUME ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

USER root

# Configure application

RUN mkdir /home/dhis
RUN cd /home/dhis && tomcat7-instance-create tomcat
RUN wget https://www.dhis2.org/download/releases/2.24/dhis.war -P /home/dhis/tomcat/webapps/
ADD dhis.conf /home/dhis/config/dhis.conf
ADD setenv.sh /home/dhis/tomcat/bin/setenv.sh
VOLUME ["/home/dhis"]

# Open Ports

EXPOSE 5000
EXPOSE 5432
EXPOSE 8080

# Start Services

WORKDIR /home/dhis
CMD service postgresql start; /home/dhis/tomcat/bin/startup.sh; tail -f /home/dhis/tomcat/logs/catalina.out
