#!/bin/bash
printf "${yellow}Testing SSH connection...\n${reset}"

ssh -p 2222 -o ConnectTimeout=5 dave@"$WINDOWS_HOST_IP" "printf '${cyan}SSH OK!${reset}\n'" || {
    printf "${red}SSH failed.${reset} Check:\n"
    printf "${yellow}  - VirtualBox NAT port forward 2222→22 active?\n"
    printf "  - Debian VM running?\n"
    printf "  - Debian VM SSH service running?${reset}\n"
    exit 1
}