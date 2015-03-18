#!/bin/bash

JAVA_OPTS="-Xmx1024m -Xms512m -XX:PermSize=256m -XX:MaxPermSize=256m -XX:NewSize=128m -Xdebug -Xnoagent"
JAVA_OPTS="$JAVA_OPTS -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5000 -Djmx.http.console.for.embedded.webserver.enabled=false"
