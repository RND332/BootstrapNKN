#!/bin/bash

# amd64
cd $HOME
sudo apt update
sudo apt install tmux
sudo wget https://download.npool.io/npool.sh && sudo chmod +x npool.sh && sudo ./npool.sh 3TY0rmxUd3M4o4r4
sleep 5
sudo systemctl stop npool.service
cd linux-amd64
sudo rm -rf ChainDB
sudo wget -O - https://nkn.org/ChainDB_pruned_latest.tar.gz  | sudo tar -xzf -
sudo systemctl start npool.service

sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 30001:30005/tcp
sudo ufw allow 443
sudo ufw allow ssh

sudo apt install firewalld -y
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service
sudo ufw --force enable

cd $HOME
sudo wget 'https://staticassets.meson.network/public/meson_cdn/v3.1.18/meson_cdn-linux-amd64.tar.gz' && tar -zxf meson_cdn-linux-amd64.tar.gz && rm -f meson_cdn-linux-amd64.tar.gz && cd ./meson_cdn-linux-amd64 && sudo ./service install meson_cdn
sudo ./meson_cdn config set --token=czwepcrkkrrkfnynlayozpor --https_port=443 --cache.size=25

sudo ./service start meson_cdn
