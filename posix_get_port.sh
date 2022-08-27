# !/bin/bash

USAGE="""Find the active port for a specific (serial / USB) device.

    Usage:
        $0
        $0 -h
"""

# Display the usage if any arguments are provided
if [ $# -ne 0 ]; then
    echo "$USAGE"
    exit 1
fi

# Get the OS. If we are on MacOS, we need to query a different path
QUERY_CMD="ls /dev/tty*"
if [[ "$OSTYPE" == "darwin"* ]]; then
    QUERY_CMD="ls /dev/cu.usb*"
fi

# Exit on an error or undefined variable
set -eu

read -p "Please unplug your device, and press enter when complete."

# Query the serial comm ports
NOT_PLUGGED_IN_ARRAY=$($QUERY_CMD)

read -p "Please (re)connect your device, and press enter when complete."

# Query the serial comm ports again
PLUGGED_IN_ARRAY=$($QUERY_CMD)

# Find the differences
POSSIBLE_PORTS=$(echo ${NOT_PLUGGED_IN_ARRAY[@]} ${PLUGGED_IN_ARRAY[@]} | tr ' ' '\n' | sort | uniq -u)

echo "Your possible serial port(s) are:"
echo "$POSSIBLE_PORTS"
