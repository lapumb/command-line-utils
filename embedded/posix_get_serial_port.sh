#!/bin/bash -eu

USAGE="""
Description:
    Follow the prompts to find the active port for a specific (serial / USB) device.

Usage:
    $0
    $0 -h

Args:
    [-h]  Show this message

Examples:
    $0
"""

# Display the usage if any arguments are provided
if [ $# -ne 0 ]; then
    echo "$USAGE"
    exit 0
fi

# Get the OS. If we are on MacOS, we need to query a different path
QUERY_CMD="ls /dev/tty*"
if [[ "$OSTYPE" == "darwin"* ]]; then
    QUERY_CMD="ls /dev/cu.usb*"
fi

read -p "Please unplug your device, and press enter when complete."

# Query the serial comm ports
NOT_PLUGGED_IN_ARRAY=$($QUERY_CMD 2> /dev/null)

read -p "Please (re)connect your device, and press enter when complete."

# Query the serial comm ports again
PLUGGED_IN_ARRAY=$($QUERY_CMD 2> /dev/null)

# Find the differences
POSSIBLE_PORTS=$(echo ${NOT_PLUGGED_IN_ARRAY[@]} ${PLUGGED_IN_ARRAY[@]} | tr ' ' '\n' | sort | uniq -u)

echo "Your possible serial port(s) are:"
echo ""
echo "$POSSIBLE_PORTS"