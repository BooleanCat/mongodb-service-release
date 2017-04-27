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
  make \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  wget \
  llvm \
  libncurses5-dev \
  libncursesw5-dev \
  xz-utils \
  tk-dev

# create vcap user
RUN useradd -ms /bin/bash vcap
RUN echo vcap:vcap1234 | chpasswd

# setup test home
ENV HOME /home/test
WORKDIR $HOME

# install BOSH CLI
RUN curl -o /usr/local/bin/bosh -s https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.1-linux-amd64
RUN chmod +rx /usr/local/bin/bosh

# install pyenv
RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
ENV PYENV_ROOT "$HOME/.pyenv"
ENV PATH "$PYENV_ROOT/bin:$PATH"
RUN echo 'eval "$( pyenv init - )"' >> ~/.bashrc

# install python
ADD src/system-tests/.python-version .python-version-temp
RUN PYTHON_VERSION="$( tr -d '\n' < .python-version-temp )" \
  && pyenv install "$PYTHON_VERSION" \
  && pyenv local "$PYTHON_VERSION"
RUN rm .python-version-temp

# install python deps
ADD src/system-tests/requirements.txt requirements.txt
RUN eval "$( pyenv init - )" \
  && pip install --upgrade pip \
  && pip install --upgrade setuptools \
  && pip install -r requirements.txt \
  && pyenv rehash
RUN rm requirements.txt
