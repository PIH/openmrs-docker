 Helpful docker commands (using imbemr-mysql as a reference):

    docker load < imbemr-mysql.tar - Imports an image that was previously exported to imbemr-mysql.tar
    docker run --name imbemr-mysql -d -p 3308:3306 pih/imbemr-mysql:latest - Creates a new container from the pih/imbemr-mysql image that is tagged as "latest", names this container "imbemr-mysql" and exposes the internal port of 3306 as 3308 to the host
    docker logs imbemr-mysql:  View the server logs of the imbemr-mysql container (can use this to investigate any startup problems, etc)
    docker exec -it  imbemr-mysql bash:  Run a bash shell in the imbemr-container and work with it interactively.  Use this to "ssh" into the mysql "vm".  Once in, you can use mysql command line client to look at the database as normal (eg. mysql -uroot -proot openmrs)
    docker stop imbemr-mysql:  Stops the container if you are done using it.  Does not delete any state or data.  You can start it up again where you left off with the docker start command
    docker start imbemr-mysql:  Starts the container back up again if you had previously stopped it, or after your computer has restarted.

If you want to purge this image and related data off of your machine (it takes up a lot of space, so you might want to remove in favor of a new one, etc):

    docker stop imbemr-mysql:  Stop the container first
    docker inspect imbemr-mysql:  Look for the "Mounts" section, and make note of the "name" property for each (particularly with Destination = /var/lib/mysql)
    docker rm imbemr-mysql:  Remove the container
    docker volume rm <uuids identified in the step above when inspecting the container>

If you are confident that you have no volumes that you need to preserve after you have removed the container, you can purge any "dangling" volumes with the command:

    docker volume rm $(docker volume ls -qf dangling=true)

Other notes if you decide to build a new image yourself, rather than using an existing one:

    docker build -t pih/imbemr-mysql:latest . : Builds a new image called pih/imbemr-mysql, tagged as latest, using the Dockerfile in the current directory
    docker run ... pih/imbemr-mysql:latest --max_allowed_packet=1G:  Increase the max_allowed_packet, which is needed for sourcing dump files with large data in certain tables.
    docker save 'pih/imbemr-mysql:latest' > imbemr-mysql.latest.tar:  Saves an image for sharing

To split a large file up into smaller files, and then re-combine them again:

    split -b 500m imbemr-mysql.tar imbemr-mysql-
    cat imbemr-mysql-* > imbemr-mysql.tar

Other ways you can use the mysql base image:

    -e MYSQL_ROOT_PASSWORD=my-secret-pw
    -v /my/custom:/etc/mysql/conf.d
    --param_name=value (supplied after the image name in the run command, see above)
    MYSQL_DATABASE variable, if specified, will ensure that DB is created automatically when the container is started for the first time
    Any files with extensions .sh, .sql and .sql.gz that are found in /docker-entrypoint-initdb.d will be executed automatically in alphabetical order when the container is started for the first time
