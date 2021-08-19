#!/bin/bash
# This script is used for configuring an x86 Ubuntu machine as a salt master through user data.
# Requires the urls: repo.saltstack.com and repo.saltproject.io to be allowed on a URL Allowlist.

# If behind corperate proxy...

#if <expression for checking>;
#then
#<set of commands to be executed>
#fi

# Add SaltStack Repos to APT Package Manager.
curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest focal main" | sudo tee /etc/apt/sources.list.d/salt.list

# Install Salt-Master.
apt update && apt upgrade -y
apt install salt-master -y

# Configure SRV.
mkdir -p /srv/{salt,pillar}

# Configure auto-accept. TODO: Auto-Accept based on grains.
sed -i 's/#auto_accept: False/auto_accept: True/g' /etc/salt/master

# Run commands based on os using the following: sudo salt -G 'os:Ubuntu' test.version

service salt-master restart
sudo reboot # Reboot machine to change DNS.
