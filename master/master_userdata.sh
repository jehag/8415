#!/bin/bash

# Install git, packages for MySQL-cluster and sysbench.
sudo apt update
sudo apt install \
    git libaio1 libmecab2 libncurses5 libtinfo5 sysbench -y

# Clone Github repository.
cd ~
git clone https://github.com/jehag/LOG8415_Inv.git

# Get MySQL-cluster management server package from URL.
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb

# Install MySQL-cluster management server.
dpkg -i mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb

# Copy ndb_mgmd config file.
mkdir /var/lib/mysql-cluster
cp ./LOG8415_Inv/master/config.ini /var/lib/mysql-cluster/

# Copy ndb_mgmd service file.
cp ./LOG8415_Inv/master/ndb_mgmd.service /etc/systemd/system/

# Start ndb_mgmd service.
sudo systemctl daemon-reload
sudo systemctl enable ndb_mgmd
sudo systemctl start ndb_mgmd

# Get MySQL-cluster server bundle from URL.
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar
mkdir install
tar -xvf mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar -C install/
cd install

# Install MySQL-cluster server.
dpkg -i mysql-common_7.6.6-1ubuntu18.04_amd64.deb
dpkg -i mysql-cluster-community-client_7.6.6-1ubuntu18.04_amd64.deb
dpkg -i mysql-client_7.6.6-1ubuntu18.04_amd64.deb
dpkg -i mysql-cluster-community-server_7.6.6-1ubuntu18.04_amd64.deb 
dpkg -i mysql-server_7.6.6-1ubuntu18.04_amd64.deb

# Copy MySQL-cluster server config file.
cp ./LOG8415_Inv/master/my.cnf /etc/mysql/

# Restart MySQL service.
sudo systemctl restart mysql
sudo systemctl enable mysql

# Get Sakila database from URL.
wget https://downloads.mysql.com/docs/sakila-db.tar.gz
tar -xvf sakila-db.tar.gz

# Install Sakila database in the cluster.
sudo mysql -u root -f ~/sakila-db/sakila-schema.sql
sudo mysql -u root -f ~/sakila-db/sakila-data.sql