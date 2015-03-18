#!/bin/bash

echo "Starting MySQL"
service mysql start

echo "Setting MySQL user/password to root/root"
mysqladmin -u root password root

if [ -d /var/lib/tomcat7/webapps ]; then
    echo "Clearing out old webapps"
   rm -fR /var/lib/tomcat7/webapps
fi

if [ -d /var/lib/tomcat7/work ]; then
    echo "Clearing out tomcat work"
   rm -fR $TOMCAT_HOME/work
fi

echo "Updating OpenMRS war file"
mkdir /var/lib/tomcat7/webapps
cp /root/openmrs/war/* /var/lib/tomcat7/webapps
chown -R tomcat7:tomcat7 /var/lib/tomcat7

echo "Removing existing application data directory"
if [ -d /usr/share/tomcat7/.OpenMRS ]; then
    rm -fR /usr/share/tomcat7/.OpenMRS
fi

echo "Adding OpenMRS modules"
mkdir /usr/share/tomcat7/.OpenMRS
mkdir /usr/share/tomcat7/.OpenMRS/modules
cp /root/openmrs/modules/* /usr/share/tomcat7/.OpenMRS/modules

echo "Adding OpenMRS configuration"
cp /root/openmrs/config/* /usr/share/tomcat7/.OpenMRS

chown -R tomcat7:tomcat7 /usr/share/tomcat7/.OpenMRS

if ! mysql -u root -proot -e 'use openmrs'; then
    echo "Initializing new database"
    mysql -u root -proot -e "create database openmrs default charset utf8; grant all privileges on openmrs.* to openmrs@localhost identified by 'openmrs'; use openmrs;"

    if [ -f /root/openmrs/db/openmrs.sql ]; then
        echo "Setting up core tables"
        mysql -u openmrs -popenmrs openmrs < /root/openmrs/db/openmrs.sql
    fi
fi

echo "Starting up Tomcat"
service tomcat7 start
