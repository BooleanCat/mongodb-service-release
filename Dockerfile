from ubuntu:zesty

ENV DOCKER_ACTIVE true

RUN apt-get update && apt-get install -y \
  bats \
  shellcheck \
  curl \
  lua5.2 \
  liblua5.2-dev \
  luarocks \
  libbson-dev \
  libmongoc-dev

# create vcap user
RUN useradd -ms /bin/bash vcap
RUN echo vcap:vcap1234 | chpasswd

# setup test home
ENV HOME /home/test
WORKDIR $HOME

# install BOSH CLI
RUN curl -o /usr/local/bin/bosh -s https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.16-linux-amd64
RUN chmod +rx /usr/local/bin/bosh

# install rocks
RUN luarocks install busted
RUN luarocks install mongorover
RUN luarocks install lua-cjson
