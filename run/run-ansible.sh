#!/bin/bash
source "$(dirname "$0")/../includes/colours.sh"

WINDOWS_HOST_IP=$(ip route show | grep default | awk '{print $3}')
TARGET_USER="${TARGET_USER:-dave}"

set -e  # exit on any error
source .env

printf "${blue}Retrieving Windows host IP from WSL...${reset}\n"
printf "${magenta}Windows host IP: $WINDOWS_HOST_IP${reset}\n"

# Put password here to avoid manual input 
cat > run/vars.yml << EOF
---
ansible_become_password: "$TARGET_PASS"
EOF

# Generate inventory
cat > run/inventory.ini << EOF
[debian_13]
debianvm ansible_host=$WINDOWS_HOST_IP ansible_port=2222 ansible_user=$TARGET_USER
EOF

# Debug
VERBOSE=""
if [ "$1" = "-v" ]; then
  VERBOSE="-vvv"
fi

# Run
ansible-playbook $VERBOSE -i run/inventory.ini site.yml --extra-vars "@run/vars.yml"

# # run project
# printf "${green}Deploying...${reset}\n"
# ansible-playbook -i run/inventory.ini site.yml --ask-pass --ask-become-pass