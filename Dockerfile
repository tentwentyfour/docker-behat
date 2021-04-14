FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /home/behat
ENV PATH $PATH:/home/behat

RUN apt-get update && \
  apt-get install -y --no-install-recommends curl git vim ca-certificates curl apt-transport-https lsb-release wget zip

RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
  sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' && \
  apt-get install -y --no-install-recommends php7.3-mysqlnd php7.3-cli php7.3-curl php7.3-bcmath php7.3-intl \
  php7.3-mbstring php7.3-xml php7.3-zip && \
  apt-get clean

# Create "behat" user with password crypted "behat"
RUN useradd -d /home/behat -m -s /bin/bash behat
RUN echo "behat:behat" | chpasswd
USER behat

# Behat alias in docker container
ADD behat /home/behat/behat
# RUN chmod +x /home/behat/behat && \
RUN mkdir -p /home/behat/data/build/html/behat/ && \
  mkdir /home/behat/composer

#chown -R behat:behat /home/behat && \
# Add "behat" to "sudoers"
#RUN echo "behat        ALL=(ALL:ALL) ALL" >> /etc/sudoers

WORKDIR /home/behat/composer
ADD composer.json /home/behat/composer/composer.json
ADD composer.lock /home/behat/composer/composer.lock
USER root
RUN chown behat:behat composer.*
USER behat
RUN curl http://getcomposer.org/installer | php && \
  php composer.phar install --prefer-source && \
  rm -rf /home/behat/.composer

WORKDIR /home/behat
CMD ["./behat"]
