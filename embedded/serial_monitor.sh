# !/bin/bash

set -e

BAUDRATE=115200
PORT=$ESPPORT

USAGE="""
Description:
    Monitor the serial output from a device.

Usage:
    $0 -p <port> [-b <baudrate>]

Args:
    -p <port>       The serial port to use (defaults to \$ESPPORT)
    [-b <baudrate]  Set the serial baurdrate (defaults to $BAUDRATE)
    [-h]            Show this message

Examples:
    $0 -h
    $0 -p /dev/cu.usbserial-1337
    $0 -p \$ESPPORT
    $0 -p \$ESPPORT -b 9600
"""

# Parse the command line argument(s)
while getopts ':p:b:h' c
do
  case $c in
    p) PORT="$OPTARG" ;;
    b) BAUDRATE="$OPTARG" ;;
    h) echo "$USAGE" && exit 0 ;;
    *) echo "$USAGE" && exit 1 ;;
  esac
done

# Make sure a port was provided
if [ -z $PORT ]; then
    echo "Please provide a port using -p"
    echo "Usage: $USAGE"
    exit 1
fi

set -u

echo "Monitoring port $PORT at baudrate $BAUDRATE (to exit, press ctrl+a followed by ctrl+x)"
picocom -b $BAUDRATE $PORT
