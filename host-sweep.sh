#!/bin/bash

# Function to validate the network range format
validate_network_range() {
    local regex="^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+$"
    if [[ ! "$1" =~ $regex ]]; then
        echo "Invalid IPv4 network range format. Please use XXX.XXX.XXX.XXX/XX (e.g., 192.168.1.1/24)."
        exit 1
    fi
}

# Prompt the user to enter the network range
read -p "Enter the network range (e.g., 192.168.1.1/24): " NETWORK

# Validate the entered network range format
validate_network_range "$NETWORK"

# Define the output file for pingable hosts
OUTPUT_FILE="pingable_hosts.txt"

# Initialize the output file
> "$OUTPUT_FILE"

# Loop through the IP addresses in the range and ping each one
for HOST in $(seq 1 254); do
    IP="${NETWORK%.*}.${HOST}"
    ping -c 1 -W 1 -4 "$IP" &> /dev/null

    # Check the exit status of the ping command
    if [ $? -eq 0 ]; then
        echo "IPv4 Host $IP is up"
        echo "$IP" >> "$OUTPUT_FILE"  # Append the pingable host to the output file
    else
        echo "IPv4 Host $IP is down"
    fi
done

echo "Pingable hosts have been logged to $OUTPUT_FILE"
