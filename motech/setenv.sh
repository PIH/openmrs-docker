#!/usr/bin/env bash

export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/"
export JAVA_OPTS="-Xmx1024m -Xms512m"
export CATALINA_OPTS="-agentlib:jdwp=transport=dt_socket,address=5000,server=y,suspend=n"
