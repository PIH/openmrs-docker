#!/bin/bash

echo "Stopping Tomcat"
service tomcat7 stop

echo "Killing Process"
ps ax | awk '/java/ && /tomcat/ && !/awk/ {print $1}' | xargs kill