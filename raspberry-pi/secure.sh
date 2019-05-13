#!/bin/bash
# This script disables password logins for SSH
# Only run it if you have SSH Keys copied to this system

sed -i 's/UsePAM yes/#UsePAM yes/' /etc/ssh/sshd_config
echo "# modified by logichromatic" | tee --append /etc/ssh/sshd_config > /dev/null
echo "UsePAM no" | tee --append /etc/ssh/sshd_config > /dev/null
echo "PermitRootLogin no" | tee --append /etc/ssh/sshd_config > /dev/null
echo "PasswordAuthentication no" | tee --append /etc/ssh/sshd_config > /dev/null
echo "PermitEmptyPasswords no" | tee --append /etc/ssh/sshd_config > /dev/null
service ssh restart
