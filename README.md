
# LEP Lab

LEP is an open-sourced all-in-one toolbox for Linux/Android performance profiling & visualization.

* [LEP Homepage](http://www.linuxep.com/)
* [LEP Git Repo](https://github.com/linuxep/)

To easier the learning and development of the LEP itself, this lab is added as a plugin of [Cloud Lab](http://tinylab.org/cloud-lab).

The following sections introduce the using of LEP with Cloud Lab.

* [LEP Lab Homepage](http://tinylab.org/lep-lab)

## Install Docker

Docker is required by LEP Lab, please install it at first:

* Linux and Mac OSX: [Docker CE](https://store.docker.com/search?type=edition&offering=community)
* Windows: [Docker Toolbox](https://www.docker.com/docker-toolbox)

Notes:

In order to run docker without password, please make sure your user is added in the docker group:

    $ sudo usermod -aG docker $USER

In order to speedup docker images downloading, please configure a local docker mirror in `/etc/default/docker`, for example:

    $ grep registry-mirror /etc/default/docker
    DOCKER_OPTS="$DOCKER_OPTS --registry-mirror=https://docker.mirrors.ustc.edu.cn"
    $ service docker restart

In order to avoid network ip address conflict, please try following changes and restart docker:

    $ grep bip /etc/default/docker
    DOCKER_OPTS="$DOCKER_OPTS --bip=10.66.0.10/16"
    $ service docker restart

If the above changes not work, try something as following:

    $ grep dockerd /lib/systemd/system/docker.service
    ExecStart=/usr/bin/dockerd -H fd:// --bip=10.66.0.10/16 --registry-mirror=https://docker.mirrors.ustc.edu.cn
    $ service docker restart

For Ubuntu 12.04, please install the new kernel at first, otherwise, docker will not work:

    $ sudo apt-get install linux-generic-lts-trusty

## Choose a working directory

If installed via Docker Toolbox, please enter into the `/mnt/sda1` directory of the `default` system on Virtualbox, otherwise, after poweroff, the data will be lost for the default `/root` directory is only mounted in DRAM.

    $ cd /mnt/sda1

For Linux or Mac OSX, please simply choose one directory in `~/Downloads` or `~/Documents`.

    $ cd ~/Documents

## Download the lab

Use Ubuntu system as an example:

Download cloud lab framework, pull images and checkout lep-lab repository:

    $ git clone https://github.com/tinyclub/cloud-lab.git
    $ cd cloud-lab/ && tools/docker/choose lep-lab

## Run and login the lab

Launch the lab and login with the user and password printed in the console:

    $ tools/docker/run lep-lab

Re-login the lab via web browser:

    $ tools/docker/vnc lep-lab

## Use the lab

After login, Open 'LEP Lab' in the desktop and it will enter into the working directory: `/labs/lep-lab/`,

### Update the source code

    $ make init

### Compile and run lepd

    $ cd lepd
    $ make ARCH=x86      // ARCH=arm
    $ ./lepd

### Run lepv web server

    $ cd lepv/app
    $ python3 ./run.py & // Must use python3 instead of python2, to avoid unicode encoding error

### Open lepv web client

    $ chromium-browser http://localhost:8889

### Analyze local lepd data

Change the server to 'localhost' instead of the default 'www.rmlink.cn'

### More

Basic usage:

    $ make help
    Usage:

    init  -- download or update lepd and lepv (1)
    _lepd -- compile and restart lepd (2)
    _lepv -- restart the lepv backend (3)
    view  -- start the lepv frontend (4)
    all   -- do (1) (2) (3) one by one

Build and restart lepd for ARM:

    $ make _lepd ARCH=arm

Monitor lepd server: localhost:

    $ make view SERVER=localhost
