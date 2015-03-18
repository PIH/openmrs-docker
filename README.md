openmrs-docker
============================

Supports setting up an OpenMRS Dev environment

Build base image

```
sudo docker build -rm -t openmrs .
```

Once this base image is built, you can use it to fire up a dev environment for any given distribution.

You will likely want to map through the 4 available ports:
* 3306: MySQL
* 8080: HTTP
* 8443: HTTPS
* 5000: Debugger

You specify the distribution by mounting a particular directory from the host into the /root/openmrs directory on the container
Assuming a parent folder named "pihemr", this is expected to have a layout of:

* pihemr/war/ -> This should contain the war file that you wish to deploy
* pihemr/modules -> This should contain the modules(s) that you wish to deploy
* pihemr/config -> This should contain any configuration files that you wish to make available in the .OpenMRS folder (eg. openmrs-runtime.properties, feature_toggles.properties)
* pihemr/db -> If you wish to initialize the system with a particular database before first starting it, it should be placed here and named openmrs.sql

To create a container with a given distribution (eg. PIH EMR), you create and run it as follows:

```
sudo docker run -t -i -d -p 3306:3306 -p 8080:8080 -p 8443:8443 -v /home/mseaton/localconfig/pihemr:/root/openmrs --name pihemr openmrs
```

This command will serve to create the container with name "pihemr", and then to start it up.
Breaking down this command, it does the following:

* "docker run -t -i -d" :  Run the container in the background and allocate a tty for the container process
* "-p 3306:3306 -p 8080:8080 -p 8443:8443" : Map ports defined within the container to available ports on the host
* "-v /home/mseaton/localconfig/pihemr:/root/openmrs" : Mount the folder located at "/home/mesaton/localconfig/pihemr" on the host to "/root/openmrs" in the container
* "--name pihemr" : The name we want to assign to this particular container, to facilitate identifying it, starting it, stopping it, etc.
* "openmrs" : The name of the image that we are creating this container from.  In this case, "openmrs" refers to the name of the image we created using the docker build command above

You connect to a started container with the "attach" command.  This is kind of like "sshing" into the server:

```
sudo docker attach pihemr
```

Once you are attached to it, there are 3 scripts available:

* ./start.sh:  This should be used to start up OpenMRS.  The first time it is run it will do all of the initial setup needed.  Subsequent runs will use the previous state.
* ./stop.sh:   This stops OpenMRS
* ./log.sh:    This will tail the catalina.out file to the console

When you are done using this, you can quit from the shell, which will serve to stop the container.

This container is still available for re-starting at a later point.  You do this with the command:

```
sudo docker start pihemr
```

From here you would attach to the container and start-up OpenMRS as indicated in the previous steps.

If you ever wish to discard this container and/or image and start from scratch, you can do so with commands like:


Remove a stopped container named pihemr:
```
sudo docker rm pihemr
```

Remove an image named openmrs:
```
sudo docker rmi openmrs
```

View running containers:
```
sudo docker ps
```

View all available containers:
```
sudo docker ps -a
```

View built images
```
sudo docker images
```
