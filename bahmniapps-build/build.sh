#!/usr/bin/env bash

read -e -p "Which fork: " -i "PIH" FORK_NAME
read -e -p "Which version: " -i "release-0.81" VERSION_NUM

sudo rm -fR /tmp/bahmniapps
git clone https://github.com/$FORK_NAME/openmrs-module-bahmniapps /tmp/bahmniapps
( cd /tmp/bahmniapps && git checkout $VERSION_NUM )

docker run -v /tmp/bahmniapps:/bahmniapps bahmniapps-build ./scripts/package.sh