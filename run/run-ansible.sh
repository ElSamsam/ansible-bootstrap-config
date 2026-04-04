#!/bin/bash
source "$(dirname "$0")/../includes/colours.sh"

WINDOWS_HOST_IP=$(ip route show | grep default | awk '{print $3}')
TARGET_USER="${TARGET_USER:-dave}"

set -e  # exit on any error
[ -f .env ] && set -a && source .env && set +a # load .env

printf "${blue}Retrieving Windows host IP from WSL...${reset}\n"
printf "${magenta}Windows host IP: $WINDOWS_HOST_IP${reset}\n"

cat > run/inventory.ini << EOF
[debian_13]
debianvm ansible_host=$WINDOWS_HOST_IP ansible_port=2222 ansible_user=$TARGET_USER
EOF

# running project
printf "${green}Deploying...${reset}\n"
ansible-playbook -i run/inventory.ini site.yml --ask-pass --ask-become-pass

# did it work??
printf "${yellow}Verifying deployment...${reset}\n"
ssh -p 2222 "$TARGET_USER@$WINDOWS_HOST_IP" "code --version && printf '${magenta}VS Code is here!${reset}\n' || printf '${red}VS Code missing${reset}\n'"