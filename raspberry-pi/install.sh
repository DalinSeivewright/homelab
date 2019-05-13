#!/bin/bash

#sudo apt-get install -y python-smbus
#sudo apt-get install -y i2c-tools

echo "Updating APT... "
apt-get update
echo "Upgrading Packages with APT..."
apt-get upgrade -y
echo "Installing required software"
apt-get install -y ufw


echo "Enabling UFW - Blocking all ports except SSH Port by default"
ufw enable && ufw default deny incoming && ufw default allow outgoing && ufw allow 22

echo "Seting up .ssh folder"
mkdir ${HOME}/.ssh
touch ${HOME}/.ssh/authorized_keys
touch ${HOME}/.ssh/sshb0t_authorized_keys

echo "Enabling github_authorized_keys file"
echo "AuthorizedKeysFile .ssh/authorized_keys .ssh/sshb0t_authorized_keys" | tee --append /etc/ssh/sshd_config > /dev/null
service ssh restart

echo "Install Rust + Cargo"
curl https://sh.rustup.rs -sSf | sh
source ${HOME}/.cargo/env

echo "Installing superintendent-quotes"
cargo install --git https://github.com/DalinSeivewright/superintendent-quotes
echo "superintendent-quotes" | tee --append ${HOME}/.profile > /dev/null


echo "Installing Docker"
curl -sSL https://get.docker.com | sh
docker run -d --restart unless-stopped \
    --name sshb0t \
    -v ${HOME}/.ssh/sshb0t_authorized_keys:/root/.ssh/authorized_keys \
    r.j3ss.co/sshb0t --user DalinSeivewright --keyfile /root/.ssh/authorized_keys
