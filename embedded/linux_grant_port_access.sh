#!/bin/bash -e

USAGE="""
Description:
    Grant the current user ($USER) access to the specified serial port without being the 'root' user.

Usage:
    $0 -p <port>
    $0 -h

Args:
    -p    Port to grant the user access to
    [-h]  Show this message

Examples:
    $0 -p /dev/cu.usbserial-14230
    $0 -p \$ESPPORT
"""

while getopts 'p:h' c
do
  case $c in
    p) UART_PORT="$OPTARG" ;;
    h) echo "$USAGE" && exit 0 ;;
    *) echo "$USAGE" && exit 1 ;;
  esac
done

# Validate a port was passed in
if [ -z $UART_PORT ]; then
    echo "Please provide a valid port using -p"
    echo "$USAGE"
    exit 1
fi

set -u

# Get the group that your port belongs to
SERIAL_PORT_GROUP=$(ls -l $UART_PORT 2> /dev/null | sed 's/  */ /g' | cut -d' ' -f4)

# Add the current user to the group
usermod -a -G $SERIAL_PORT_GROUP $USER

echo "$USER has successfully been added to the $SERIAL_PORT_GROUP group!"
echo "For this change to take effect, please reboot your computer."
