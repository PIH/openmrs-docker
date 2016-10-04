FROM ubuntu:16.04

MAINTAINER Michael Seaton <mseaton@pih.org>

# Install packages

RUN apt-get update
RUN apt-get -y install openjdk-8-jdk
RUN apt-get -y install tomcat7-user
RUN apt-get -y install activemq
RUN apt-get -y install curl

RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get -y install mysql-server

# Configure ActiveMQ

RUN ln -s /etc/activemq/instances-available/main /etc/activemq/instances-enabled/main
RUN sed -e 's/<broker /<broker schedulerSupport="true" /' -i /etc/activemq/instances-enabled/main/activemq.xml
RUN service activemq restart
VOLUME ["/data/activemq", "/var/log/activemq", "/opt/activemq/conf"]

# Configure database

VOLUME ["/etc/mysql", "/var/log/mysql", "/var/lib/mysql"]

# Configure application

RUN mkdir /home/motech
RUN cd /home/motech && tomcat7-instance-create tomcat
RUN curl -L "http://nexus.motechproject.org/service/local/artifact/maven/redirect?r=releases&g=org.motechproject&a=motech-platform-server&v=RELEASE&e=war" -o /home/motech/tomcat/webapps/motech.war
ADD setenv.sh /home/motech/tomcat/bin/setenv.sh
VOLUME ["/home/motech"]

# Open Ports

EXPOSE 5000
EXPOSE 61616
EXPOSE 3306
EXPOSE 8080

# Start Services

WORKDIR /home/motech
CMD service activemq start; service mysql start; /home/motech/tomcat/bin/startup.sh; tail -f /home/motech/tomcat/logs/catalina.out
