#!/bin/bash

USER=${SUDO_USER}
if [ -z "${USER}" ]; then
  echo "You must run this script with sudo, friendo."
  exit 1;
fi
USER_HOME=/home/${SUDO_USER}
if [ ! -d "${USER_HOME}" ]; then
  echo "Your user must have a home directory."
  exit 1;
fi

echo "Updating APT... "
apt-get update
echo "Upgrading Packages with APT..."
apt-get upgrade -y
echo "Installing required software"
apt-get install -y ufw


echo "Enabling UFW - Blocking all ports except SSH Port by default"
(yes | ufw enable) && ufw default deny incoming && ufw default allow outgoing && ufw allow 22

echo "Seting up .ssh folder"
mkdir ${USER_HOME}/.ssh
touch ${USER_HOME}/.ssh/authorized_keys
touch ${USER_HOME}/.ssh/sshb0t_authorized_keys

echo "Enabling github_authorized_keys file"
echo "AuthorizedKeysFile .ssh/authorized_keys .ssh/sshb0t_authorized_keys" | tee --append /etc/ssh/sshd_config > /dev/null
service ssh restart

echo "Install Rust + Cargo"
curl https://sh.rustup.rs -sSf | sh -s -- -y
source ${USER_HOME}/.cargo/env

echo "Installing superintendent-quotes"
cargo install --git https://github.com/DalinSeivewright/superintendent-quotes
echo "superintendent-quotes" | tee --append ${USER_HOME}/.profile > /dev/null


echo "Installing Docker"
curl -sSL https://get.docker.com | sh

docker run -d --restart unless-stopped \
    --name sshb0t \
    -v ${USER_HOME}/.ssh/sshb0t_authorized_keys:/root/.ssh/authorized_keys \
    r.j3ss.co/sshb0t --user DalinSeivewright --keyfile /root/.ssh/authorized_keys
