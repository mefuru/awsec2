#!/bin/bash
# Simple setup.sh for configuring Ubuntu 16.04 LTS EC2 instance
# for headless setup. 

# Install nvm: node-version manager
# https://github.com/creationix/nvm
sudo apt-get install -y git
sudo apt-get install -y curl
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash

# Load nvm and install latest production node
source $HOME/.nvm/nvm.sh
nvm install v6.0.0
nvm install v0.12.6
nvm install v7.8.0
nvm use v6.0.0

# Node.js REPL
# https://linux.die.net/man/1/rlwrap
sudo apt install -y rlwrap

# Install emacs
# http://wikemacs.org/wiki/Installing_Emacs_on_GNU/Linux#Emacs_25
sudo apt-add-repository -y ppa:adrozdoff/emacs
sudo apt update
sudo apt install -y emacs25

# Install Prelude for emacs24
# http://batsov.com/prelude/      
curl -L http://git.io/epre | sh

# Install MongoDB - Updated Aug 2016
# http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get -y update
udo apt-get -y install -y mongodb-org
sudo mkdir -p /data/db/
sudo chown `id -u` /data/db

# Generate ssh on server
ssh-keygen && cat ~/.ssh/id_rsa.pub

# REDIS - http://redis.io/topics/quickstart
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
sudo apt-get -y install make
sudo apt-get -y install build-essential
make
sudo apt install -y redis-server

# git pull and install dotfiles as well
cd $HOME
if [ -d ./dotfiles/ ]; then
    mv dotfiles dotfiles.old
fi
if [ -d .emacs.d/ ]; then
    mv .emacs.d .emacs.d~
fi
git clone https://github.com/startup-class/dotfiles.git
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sb dotfiles/.bashrc_custom .
ln -sf dotfiles/.emacs.d .

# Set timezone to London
# http://askubuntu.com/questions/323131/setting-timezone-from-terminal
sudo timedatectl set-timezone Europe/London

# needed for xml2json npm module to work
# https://github.com/nodejs/node-gyp
# node-gyp is a cross-platform command-line tool written in Node.js for compiling native addon modules for Node.js
sudo apt -y install node-gyp
node-gyp rebuild
