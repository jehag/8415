#!/bin/bash

sudo apt update
sudo apt install \
    git libclass-methodmaker-perl -y

cd ~
git clone https://github.com/jehag/LOG8415_Inv.git

wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-data-node_7.6.6-1ubuntu18.04_amd64.deb

dpkg -i mysql-cluster-community-data-node_7.6.6-1ubuntu18.04_amd64.deb

cp ./LOG8415_Inv/subordinates/my.cnf /etc/

mkdir -p /usr/local/mysql/data

cp ./LOG8415_Inv/subordinates/ndbd.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable ndbd
sudo systemctl start ndbd