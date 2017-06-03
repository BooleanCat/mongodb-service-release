from ubuntu:trusty

ENV DOCKER_ACTIVE true

# add bats PPA
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D16DD0BD5F28EA3F
RUN echo "deb http://ppa.launchpad.net/duggan/bats/ubuntu trusty main" >> /etc/apt/sources.list

RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty-backports restricted main universe" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
  bats \
  shellcheck \
  curl \
  gcc \
  make \
  libreadline6-dev \
  unzip

# create vcap user
RUN useradd -ms /bin/bash vcap
RUN echo vcap:vcap1234 | chpasswd

# setup test home
ENV HOME /home/test
WORKDIR $HOME

# install BOSH CLI
RUN curl -o /usr/local/bin/bosh -s https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.16-linux-amd64
RUN chmod +rx /usr/local/bin/bosh

# install lua
RUN curl -o lua-5.3.4.tar.gz -s https://www.lua.org/ftp/lua-5.3.4.tar.gz
RUN tar -xzf lua-5.3.4.tar.gz
RUN cd lua-5.3.4 && make linux test && make install
RUN rm -r lua-5.3.4 lua-5.3.4.tar.gz

# install luarocks
RUN curl -o luarocks-2.4.2.tar.gz -s http://luarocks.github.io/luarocks/releases/luarocks-2.4.2.tar.gz
RUN tar -xzf luarocks-2.4.2.tar.gz
RUN cd luarocks-2.4.2 && ./configure
RUN cd luarocks-2.4.2 && make build && make install
RUN rm -r luarocks-2.4.2 luarocks-2.4.2.tar.gz

# install rocks
RUN luarocks install busted
