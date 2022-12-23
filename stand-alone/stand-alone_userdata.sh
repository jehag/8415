#!/bin/bash

# Install MySQL-server and sysbench.
sudo apt-get update
sudo apt-get install \
        mysql-server sysbench -y

# Get Sakila database from URL.
wget https://downloads.mysql.com/docs/sakila-db.tar.gz
tar -xvf sakila-db.tar.gz

# Install Sakila database in the cluster.
sudo mysql -u root -f ~/sakila-db/sakila-schema.sql
sudo mysql -u root -f ~/sakila-db/sakila-data.sql