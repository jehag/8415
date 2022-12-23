#!/bin/bash

sudo apt update
sudo apt install \
    git libaio1 libmecab2 libncurses5 libtinfo5 sysbench -y


cd ~
git clone https://github.com/jehag/LOG8415_Inv.git

wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb

dpkg -i mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb

mkdir /var/lib/mysql-cluster
cp ./LOG8415_Inv/master/config.ini /var/lib/mysql-cluster/

cp ./LOG8415_Inv/master/ndb_mgmd.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable ndb_mgmd
sudo systemctl start ndb_mgmd

wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar
mkdir install
tar -xvf mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar -C install/
cd install

dpkg -i mysql-common_7.6.6-1ubuntu18.04_amd64.deb
dpkg -i mysql-cluster-community-client_7.6.6-1ubuntu18.04_amd64.deb
dpkg -i mysql-client_7.6.6-1ubuntu18.04_amd64.deb
dpkg -i mysql-cluster-community-server_7.6.6-1ubuntu18.04_amd64.deb 
dpkg -i mysql-server_7.6.6-1ubuntu18.04_amd64.deb

cp ./LOG8415_Inv/master/my.cnf /etc/mysql/

sudo systemctl restart mysql
sudo systemctl enable mysql

wget https://downloads.mysql.com/docs/sakila-db.tar.gz
tar -xvf sakila-db.tar.gz

sudo mysql -u root -f ~/sakila-db/sakila-schema.sql
sudo mysql -u root -f ~/sakila-db/sakila-data.sql
