#!/bin/bash
# This script is used for configuring an x86 Ubuntu machine as a salt master through user data.
# Requires the urls: repo.saltstack.com and repo.saltproject.io to be allowed on a URL Allowlist.

# User Set Variables

# Automated Variables

SALTMASTERPRIVATEIP = "127.0.0.1"  # TODO: Set with Terraform template.

# If behind corperate proxy...

#if <expression for checking>;
#then
#<set of commands to be executed>
#fi

# Add SaltStack Repos to APT Package Manager.
curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest focal main" | sudo tee /etc/apt/sources.list.d/salt.list

# Install Salt-Minion.
apt update && apt upgrade -y
apt install salt-minion -y

# Configure Salt Minion.
sed -i "s/#master: salt/master: $SALTMASTERPRIVATEIP/g" /etc/salt/minion
service salt-minion restart
