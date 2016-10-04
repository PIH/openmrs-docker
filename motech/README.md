pih-docker-motech
============================

Usage:

* Build image locally:  **docker build -t motech .**
  * **-t motech**: Records this image with the local docker engine as "motech"
  * **.**: - Build from the current directory (should be relative to current directory)
  
* Create (and run) container from an image:  **docker run -d -p 8081:8080 -p 3307:3306 -p 5001:5000 --link=dhis2 --name motech motech**
  * **-d**:  Run in detached mode.  This keeps the container running in the background.
  * **-p HOST:CONTAINER**: Enables connection from host on a given port, to container on a given port
    * Tomcat is required.  Optional are 3306 (MySQL), 61616 (ActiveMQ) and 5000 (Debugger)
  * **--link=dhis2**: This is necessary for this container to be able to connect to the DHIS2 container, at least until another approach is taken (eg. docker-compose)
  * **--name motech**: Names the container for later reference.
  * **motech**: The name of the image to build this container from (should match the tag from above build)
  
* Stop a running container:  **docker stop motech**
* Re-start a named container:  **docker start motech**
* To run a command in a running container (commonly just bash):  **docker exec -ti dhis2 bash**
* To delete the container:  **docker rm -f motech**
* To delete the image:  **docker rmi motech**

* Fire up a new fresh instance of the container and poke around (to confirm set up is right, etc):  **docker run --rm -t -i motech /bin/bash**
  * **--rm**:  Automatically clean up the container and remove the filesystem when the container exit (since this is not meant to persist)
  * **-t -i**: Needed to run as an interactive process (like a shell) (allocate a pseudo-tty, and keep stdin open)
  * **motech**: The name of the image to build this container from (should match the tag from above build)
  * **/bin/bash**: The command to run (in this case, simply bash in order to be able to poke around)

* Get a shell to work with any exposed volumes: **docker run --rm --volumes-from motech -t -i ubuntu:16.04 /bin/bash**
  * **--volumes-from motech**: Mount any filesystem volumes that are exposed by the motech container, so we can work with them
  * Basically, this uses an ubuntu:16.04 image as a minimal image we already have lying around, and mounts the files from a running container

* Tail the log file: **docker run --rm --volumes-from motech -t -i ubuntu:16.04 tail -f /home/motech/tomcat/logs/catalina.out**

Developer hints:

Due to file size limitations in github, we do not keep the war file locally, but rather download it with this:

RUN curl -L "http://nexus.motechproject.org/service/local/artifact/maven/redirect?r=releases&g=org.motechproject&a=motech-platform-server&v=RELEASE&e=war" -o /home/motech/tomcat/webapps/motech.war

During development, it is faster to add this locally, in which case you can add the war to the dhis2 directory, and replace the above with:

ADD motech.war /home/motech/tomcat/webapps/motech.war
