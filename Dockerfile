from ubuntu:trusty

ENV DOCKER_ACTIVE true

# add bats PPA
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D16DD0BD5F28EA3F
RUN echo "deb http://ppa.launchpad.net/duggan/bats/ubuntu trusty main" >> /etc/apt/sources.list

RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty-backports restricted main universe" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
  bats \
  shellcheck \
  curl

# create vcap user
RUN useradd -ms /bin/bash vcap
RUN echo vcap:vcap1234 | chpasswd

# setup test home
ENV HOME /home/test
WORKDIR $HOME

# install BOSH CLI
RUN curl -o /usr/local/bin/bosh -s https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.16-linux-amd64
RUN chmod +rx /usr/local/bin/bosh
