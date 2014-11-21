docker-behat
============

This repository is the source of `tvial/behat` which brings :  
- php5-cli with PHP 5.5  
- behat 3.0 / mink 1.5  
- all needed dependencies  

## Install

    docker pull 1024/behat

## Usage

On your host, you can add the `behat()` function to your shell environnement:  

    function behat() { docker run -t -i --rm -h docker-behat -v $(pwd):/home/behat/data:rw tvial/behat /bin/bash -c "behat $*" ;}

You can now call `behat` command from your host, it will be executed in your docker container.
Note that the container will be removed when the behat process will end usins `--rm`.  
A `data` folder is mounted read/write to your current folder (the one you launched docker-behat).  

Or:

    docker run -t -i -h docker-behat -v $(pwd):/home/behat/data:rw 1024/behat /bin/bash  

You should see a prompt containing `[ docker-behat ]` and have `behat` command available.  

## Build

If you need adapt the project to your needs, clone, modify the `Dockerfile` and from the source directory, run:

    docker build -t 1024/behat .

Also available via [Docker Index](https://index.docker.io/u/tvial/behat/).
