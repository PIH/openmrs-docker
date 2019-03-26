FROM ubuntu:16.04

MAINTAINER Michael Seaton <mseaton@pih.org>

# Install packages

RUN apt-get update
RUN apt-get -y install git ruby-dev nodejs npm firefox xvfb zip
RUN npm install -g bower
RUN npm install -g grunt-cli
RUN gem install compass
RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN echo '{ "allow_root": true, "registry": "https://registry.bower.io" }' > /root/.bowerrc

WORKDIR /bahmniapps/ui
CMD scripts/package.sh
