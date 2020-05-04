pih-docker bahmniapps-build
============================

This image can be used as an isolated environment to build the bahmniapps codebase from source.

Usage:

* Build image locally.  From this directory:  **docker build -t bahmniapps-build .**
  * **-t bahmniapps-build**: Records this image with the local docker engine as "bahmniapps-build"
  * **.**: - Build from the current directory (should be relative to current directory)
  
* Use this image to build code:
  * Check out bahmniapps fork and branch that you wish to build.
      
      
	  git clone https://github.com/PIH/openmrs-module-bahmniapps.git
	  cd openmrs-module-bahmniapps
	  git checkout release-0.81

  * Run **docker run -v /absolute/path/where/you/have/bahmniapps/cloned:/bahmniapps bahmniapps-build ./scripts/package.sh**

This will package up the bahmniapps code into the target/bahmniapps.zip and into dist