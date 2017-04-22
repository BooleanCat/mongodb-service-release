from ubuntu:trusty

RUN apt-get update && apt-get install -y git

# install bats
RUN git clone https://github.com/sstephenson/bats.git
RUN cd bats && ./install.sh /usr/local
RUN rm -rf bats

# create vcap user
RUN useradd -ms /bin/bash vcap
RUN echo vcap:vcap1234 | chpasswd

# setup test home
ENV TEST_HOME /home/test
ENV HOME /home/test
WORKDIR $HOME
