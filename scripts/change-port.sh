#!/bin/bash

# Prompt the user for a port number
read -p "Enter the port to use for coolify (leave empty to revert back to default port): " port

# Path to the .env file
env_file="/data/coolify/source/.env"

# Check if the .env file exists
if [ ! -f "$env_file" ]; then
    echo "Error: .env file does not exist at $env_file."
    echo "Make you already ran the official installation script before running this."
    exit 1
fi

if [[ -n $port ]]; then
    # The user provided a port, add/update the APP_PORT line
    if grep -q "APP_PORT=" "$env_file"; then
        # APP_PORT exists, update it
        sed -i "s/APP_PORT=.*/APP_PORT=$port/" "$env_file"
    else
        # APP_PORT does not exist, add it
        echo "APP_PORT=$port" >> "$env_file"
    fi
    echo "Set APP_PORT to $port in $env_file."
else
    # No port provided, remove the APP_PORT line if it exists
    sed -i '/APP_PORT=/d' "$env_file"
    echo "Removed APP_PORT from $env_file."
fi

if [[ -z $port ]]; then
    port=8000
fi

echo -e "\nRestarting Coolify by running installation script...\n"

sleep 1

curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

echo -e "\n-------------"
echo "Ignore the link shown above, use the link below."
echo "Visit http://$(curl -4s https://ifconfig.io):$port to get started."
echo "Make sure that port above is not blocked by your firewall, and if you're hosting at home, make sure it is port forwarded."