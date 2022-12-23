#!/bin/bash

# Install package for MySQL-cluster data node.
sudo apt update
sudo apt install \
    git libclass-methodmaker-perl -y

# Clone Github repository.
cd ~
git clone https://github.com/jehag/LOG8415_Inv.git

# Get MySQL-cluster data node package from URL.
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-data-node_7.6.6-1ubuntu18.04_amd64.deb

# Install MySQL-cluster data node.
dpkg -i mysql-cluster-community-data-node_7.6.6-1ubuntu18.04_amd64.deb

# Copy MySQL-cluster data node config file.
cp ./LOG8415_Inv/subordinates/my.cnf /etc/

# Create data node data repository.
mkdir -p /usr/local/mysql/data

# Copy ndbd service file.
cp ./LOG8415_Inv/subordinates/ndbd.service /etc/systemd/system/

# Start ndbd service.
sudo systemctl daemon-reload
sudo systemctl enable ndbd
sudo systemctl start ndbd