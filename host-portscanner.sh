#!/bin/bash

# Validate if the pingable_hosts.txt file exists
if [ ! -f "pingable_hosts.txt" ]; then
    echo "The pingable_hosts.txt file does not exist. Please run the ping sweep script first."
    exit 1
fi

# Function to scan specific ports and log results
scan_specific_ports() {
    read -p "Enter the ports to scan (comma-separated, e.g., 80,443,22): " PORTS
    OUTPUT_FILE="open_ports_specific.txt"
    > "$OUTPUT_FILE"

    for HOST in $(cat "pingable_hosts.txt"); do
        echo "Scanning open ports on $HOST..."
        for PORT in $(echo "$PORTS" | tr ',' ' '); do
            nc -z -w 1 "$HOST" "$PORT"
            if [ $? -eq 0 ]; then
                echo "Port $PORT is open on $HOST" >> "$OUTPUT_FILE"
            fi
        done
        echo ""
    done

    echo "Open ports have been logged to $OUTPUT_FILE"
}

# Function to scan all ports and log results
scan_all_ports() {
    OUTPUT_FILE="open_ports_host.txt"
    > "$OUTPUT_FILE"

    for HOST in $(cat "pingable_hosts.txt"); do
        echo "Scanning open ports on $HOST..."
        for PORT in {1..65535}; do
            nc -z -w 1 "$HOST" "$PORT"
            if [ $? -eq 0 ]; then
                echo "Port $PORT is open on $HOST" >> "$OUTPUT_FILE"
            fi
        done
        echo ""
    done

    echo "Open ports have been logged to $OUTPUT_FILE"
}

# Prompt the user to select a scanning option
read -p "Choose a scanning option (1 - Specific Ports, 2 - All Ports): " OPTION

case $OPTION in
    1)
        scan_specific_ports
        ;;
    2)
        scan_all_ports
        ;;
    *)
        echo "Invalid option. Please choose 1 for Specific Ports or 2 for All Ports."
        ;;
esac
