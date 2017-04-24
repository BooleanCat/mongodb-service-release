from ubuntu:trusty

ENV DOCKER_ACTIVE true

# add bats PPA
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D16DD0BD5F28EA3F
RUN echo "deb http://ppa.launchpad.net/duggan/bats/ubuntu trusty main" >> /etc/apt/sources.list

RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty-backports restricted main universe" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y bats shellcheck curl git

# create vcap user
RUN useradd -ms /bin/bash vcap
RUN echo vcap:vcap1234 | chpasswd

# setup test home
ENV HOME /home/test
WORKDIR $HOME

# install go
RUN curl -o go1.8.1.linux-amd64.tar.gz -s https://storage.googleapis.com/golang/go1.8.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.8.1.linux-amd64.tar.gz
RUN rm go1.8.1.linux-amd64.tar.gz
ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH $HOME/go

# install ginkgo
RUN go get github.com/onsi/ginkgo/ginkgo
RUN go get github.com/onsi/gomega
ENV PATH $PATH:$HOME/go/bin
