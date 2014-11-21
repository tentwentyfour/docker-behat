docker-behat
============

This repository is the source of `tvial/behat` which brings :  
- php5-cli with PHP 5.6
- PHP modules: php5-mysqlnd & php5-curl
- behat 3.0 / mink 2.0
- mink-selenium-driver 1.2
- mink-goutte-driver 1.1
- phactory 0.4.3  

## Install

    docker pull 1024/behat

## Usage

On your host, you can add the `behat()` function to your shell environnement:  

    function behat() { docker run -ti --rm -h docker-behat -v $(pwd):/home/behat/data:rw 1024/behat /bin/bash -c "behat $*" ;}

You can now call `behat` command from your host, it will be executed in your docker container.
Note that the container will be removed when the behat process will end usins `--rm`.  
A `data` folder is mounted read/write to your current folder (the one you launched docker-behat).  

Or:

    docker run -t -i -h docker-behat -v $(pwd):/home/behat/data:rw 1024/behat /bin/bash  

You should see a prompt containing `[ docker-behat ]` and have `behat` command available.  

### Using Phactory

If you want to use [Phactory](http://phactory.org/) with your behat scenarios, you will need to link this container to your database container:

    docker run --rm --link mysqldb:db -e DB_USER=admin -e DB_PASS=thepassword -e DB_NAME=dbname -ti -h docker-behat -v $(pwd):/home/behat/data:rw 1024/behat /bin/bash -c "behat"

## Build

If you need adapt the project to your needs, clone, modify the `Dockerfile` and from the source directory, run:

    docker build -t 1024/behat .
