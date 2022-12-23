#!/bin/bash

# Install python virtual environment.
sudo apt-get update
sudo apt-get install \
    python3-venv -y

# Clone Github repository.
cd /home/ubuntu
git clone https://github.com/jehag/LOG8415_Inv.git

# Create Python virtual environment.
cd ./LOG8415_Inv/proxy
python3 -m venv base
source base/bin/activate
pip install -r req.txt