FROM ubuntu:14.04.2

MAINTAINER Partners In Health <medinfo@pih.org>

# Install required dependencies
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install -y openjdk-7-jdk tomcat7 mysql-server-5.6

# Create folders that reflect what is expected to be mounted from host
RUN mkdir /root/openmrs
RUN mkdir /root/openmrs/war
RUN mkdir /root/openmrs/modules
RUN mkdir /root/openmrs/config
RUN mkdir /root/openmrs/db

WORKDIR /root

EXPOSE 3306
EXPOSE 8080
EXPOSE 8443
EXPOSE 5000

ADD *.sh ./
RUN chmod +x *.sh
RUN mv env.sh /usr/share/tomcat7/bin/setenv.sh

CMD /bin/bash
