FROM ubuntu:16.04
MAINTAINER Samundra Shrestha <admin@samundra.com.np>
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN ln -sf /usr/share/zoneinfo/Asia/Bangkok /etc/localtime
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update && apt-get install -y software-properties-common  bash-completion  vim  curl \
    supervisor nginx unzip git curl cron sudo postgresql-client-9.5 redis-tools \
    build-essential libssl-dev

# Vagrant Configurations
RUN export uid=1000 gid=1000 \
    && mkdir -p /home/vagrant \
    && echo "vagrant:x:${uid}:${gid}:vagrant,,,:/home/vagrant:/bin/bash" >> /etc/passwd \
    && echo "vagrant:x:${uid}:" >> /etc/group \
    && echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant \
    && chmod 0400 /etc/sudoers.d/vagrant \
    && chown ${uid}:${gid} -R /home/vagrant \
    && usermod -g www-data vagrant

ENV HOME /home/vagrant
USER vagrant
VOLUME /vagrant

RUN cd $HOME && \
    curl https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh |\
    bash

RUN export NVM_DIR=$HOME/.nvm && . $HOME/.nvm/nvm.sh && nvm install 7.4 && \
    nvm list && nvm use 7.4
RUN ls -al $HOME/
COPY .bashrc $HOME/.bashrc
RUN /bin/bash -c 'source $HOME/.bashrc; npm version;npm install -g gulp typings yarn;'
RUN /bin/bash -c 'source $HOME/.bashrc; gulp --version; typings --version; yarn --version'

USER root
RUN add-apt-repository ppa:ondrej/php && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C && \
    apt-get update && apt-get install -y \
    php7.0-fpm \
    php7.0-cli \
    php7.0-dev \
    php7.0-gd \
    php7.0-imap \
    php7.0-intl \
    php7.0-json \
    php7.0-mcrypt \
    php7.0-mysql \
    php7.0-mbstring \
    php7.0-ldap \
    php7.0-zip \
    php7.0-xml \
    php7.0-pgsql \
    php7.0-curl \
    php-pear && \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Comopser
RUN curl -sS https://getcomposer.org/installer|\
  php -- --install-dir=/usr/local/bin --filename=composer && \
  chmod +x /usr/local/bin/composer

# mandatory dependencies
RUN chmod 777 /tmp -R \
    && cd /tmp \
    && git clone -b php7 https://github.com/phpredis/phpredis.git \
    && cd /tmp && mv phpredis/ /etc/ && cd /etc/phpredis \
    && phpize && ./configure && make && make install \
    && echo 'extension=redis.so' > /etc/php/7.0/mods-available/redis.ini  \
    && ln -s /etc/php/7.0/mods-available/redis.ini /etc/php/7.0/cli/conf.d/redis.ini

# Xdebug
RUN pecl install -f xdebug
COPY xdebug.ini /etc/php/7.0/mods-available/xdebug.ini
RUN ln -s /etc/php/7.0/mods-available/xdebug.ini /etc/php/7.0/fpm/conf.d/xdebug.ini
RUN ln -s /etc/php/7.0/mods-available/xdebug.ini /etc/php/7.0/cli/conf.d/xdebug.ini
RUN mkdir -p /run/php/ && touch /run/php/php7.0-fpm.sock
RUN /bin/bash -c 'service php7.0-fpm restart;'

# Zsh
RUN apt-get update && apt-get install -y zsh && export TERM=xterm-256color SHELL=/bin/zsh \
    && curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh > $HOME/install.sh \
    && chmod +x $HOME/install.sh && sh $HOME/install.sh
COPY .zshrc $HOME/.zshrc
COPY .aliases $HOME/.aliases
# VIM
# RUN git clone --recursive https://github.com/samundra/dot-vim.git $HOME/.vim --depth=1

ENV NVM_DIR $HOME/.nvm

EXPOSE 9000
EXPOSE 80
EXPOSE 443

USER vagrant
WORKDIR /vagrant

CMD /bin/zsh
