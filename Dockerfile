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
  git \
  autoconf \
  bison \
  build-essential \
  libssl-dev \
  libyaml-dev \
  libreadline6-dev \
  zlib1g-dev \
  libncurses5-dev \
  libffi-dev \
  libgdbm3 \
  libgdbm-dev

# create vcap user
RUN useradd -ms /bin/bash vcap
RUN echo vcap:vcap1234 | chpasswd

# setup test home
ENV HOME /home/test
WORKDIR $HOME

# install BOSH CLI
RUN curl -o /usr/local/bin/bosh -s https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.16-linux-amd64
RUN chmod +rx /usr/local/bin/bosh

# install rbenv
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
ENV RBENV_ROOT "$HOME/.rbenv"
ENV PATH "$RBENV_ROOT/bin:$PATH"

# install ruby
ADD src/system-tests/.ruby-version .ruby-version-temp
RUN RUBY_VERSION="$( tr -d '\n' < .ruby-version-temp )" \
  && rbenv install "$RUBY_VERSION" \
  && rbenv local "$RUBY_VERSION"
RUN rm .ruby-version-temp

# install gems
ADD src/system-tests/Gemfile Gemfile
ADD src/system-tests/Gemfile.lock Gemfile.lock
RUN eval "$(rbenv init -)" \
  && gem install bundler \
  && bundle install
RUN rm Gemfile
RUN rm Gemfile.lock
ENV PATH "$RBENV_ROOT/versions/2.4.1/bin:$PATH"
