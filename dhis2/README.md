pih-docker-dhis2
============================

Usage:

* Build image locally:  **docker build -t dhis2 .**
  * **-t dhis2**: Records this image with the local docker engine as "dhis2"
  * **.**: - Build from the current directory (should be relative to current directory)
  
* Create (and run) container from an image:  **docker run -d -p 8080:8080 --name dhis2 dhis2**
  * **-d**:  Run in detached mode.  This keeps the container running in the background.
  * **-p HOST:CONTAINER**: Enables connection from host on a given port, to container on a given port
    * Tomcat is required.  Optional are 5432 (Postgres) and 5000 (Debugger)
  * **--name dhis2**: Names the container for later reference.
  * **dhis2**: The name of the image to build this container from (should match the tag from above build)

* Stop a running container:  **docker stop dhis2**
* Re-start a named container:  **docker start dhis2**
* To run a command in a running container (commonly just bash):  **docker exec -ti dhis2 bash**
* To delete the container:  **docker rm -f dhis2**
* To delete the image:  **docker rmi dhis2**

* Fire up a new fresh instance of the container and poke around (to confirm set up is right, etc):  **docker run --rm -t -i dhis2 /bin/bash**
  * **--rm**:  Automatically clean up the container and remove the filesystem when the container exit (since this is not meant to persist)
  * **-t -i**: Needed to run as an interactive process (like a shell) (allocate a pseudo-tty, and keep stdin open)
  * **dhis2**: The name of the image to build this container from (should match the tag from above build)
  * **/bin/bash**: The command to run (in this case, simply bash in order to be able to poke around)

* Get a shell to work with any exposed volumes: **docker run --rm --volumes-from dhis2 -t -i ubuntu:16.04 /bin/bash**
  * **--volumes-from dhis2**: Mount any filesystem volumes that are exposed by the dhis2 container, so we can work with them
  * Basically, this uses an ubuntu:16.04 image as a minimal image we already have lying around, and mounts the files from a running container

* Tail the log file: **docker run --rm --volumes-from dhis2 -t -i ubuntu:16.04 tail -f /home/dhis2/tomcat/logs/catalina.out**

Developer hints:

Due to file size limitations in github, we do not keep the dhis.war file locally, but rather download it with this:

RUN wget https://www.dhis2.org/download/releases/2.24/dhis.war -P /home/dhis/tomcat/webapps/

During development, it is faster to add this locally, in which case you can add the war to the dhis2 directory, and replace the above with:

ADD dhis.war /home/dhis/tomcat/webapps/dhis.war

When we are ready to start with a starter database, we can do this as follows:
* ADD venn.sql.gz /tmp/venn.sql.gz
* RUN gunzip -c /tmp/venn.sql.gz > /tmp/dhis.sql
* Append this to the end of the postgres DB command:
  * && psql -d dhis2 -f /tmp/dhis.sql