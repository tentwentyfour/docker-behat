FROM debian:stretch
MAINTAINER David Raison <david@tentwentyfour.lu>

# Update and install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y curl git vim ca-certificates curl apt-transport-https lsb-release wget
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
RUN apt-get update
RUN apt-get install -y php5.6-mysqlnd php5.6-cli php5.6-curl \
        php5.6-bcmath php5.6-intl php5.6-mbstring php5.6-xml

# Create "behat" user with password crypted "behat"
RUN useradd -d /home/behat -m -s /bin/bash behat
RUN echo "behat:behat" | chpasswd

# Behat alias in docker container
ADD behat /home/behat/behat
RUN chmod +x /home/behat/behat

RUN mkdir -p /home/behat/data/build/html/behat/

# Fix permissions
RUN chown -R behat:behat /home/behat

# Add "behat" to "sudoers"
RUN echo "behat        ALL=(ALL:ALL) ALL" >> /etc/sudoers

USER behat
WORKDIR /home/behat
ENV HOME /home/behat
ENV PATH $PATH:/home/behat

# Install Behat
RUN mkdir /home/behat/composer
ADD composer.json /home/behat/composer/composer.json
RUN cd /home/behat/composer && curl http://getcomposer.org/installer | php
RUN cd /home/behat/composer && php composer.phar install --prefer-source
