#!/bin/bash -e

USAGE="
Description:
    Erase non-encrypted flash data on an Espressif SOC.

Usage:
    $0
    $0 [-p PORT]
    $0 [-c CHIP_TYPE]
    $0 [-p PORT] [-c CHIP_TYPE]
    $0 [-h]

Args:
    [-p]  The serial port to use (defaults to \$ESPPORT)
    [-c]  The Espressif chip type (defaults to \$IDF_TARGET)
    [-h]  Show this message

Examples:
    $0
    $0 -h
    $0 -p /dev/cu.usbserial-1337
    $0 -p /dev/cu.usbserial-1337 -c esp32s3
"

CHIP=$IDF_TARGET
PORT=$ESPPORT

# Parse the command line arguments
while getopts ':p:h' c
do
  case $c in
    p) PORT="$OPTARG" ;;
    h) echo "$USAGE" && exit 0 ;;
    *) echo "$USAGE" && exit 1 ;;
  esac
done

if [ -z "$PORT" ]; then
    echo "You must provide a serial port"
    echo "$USAGE"
    exit 1
fi

set -u

# Warning about erasing flash, ask for confirmation before proceeding
echo ""
echo "WARNING: You are about to erase flash, which will delete any unsecure data on the board."
echo "         This cannot be undone."
echo ""
echo "  After erasing flash, a new firmware image will need to be flashed"
echo "  to the device"
echo ""

# Ask for user confirmation before proceeding (default: don't proceed)
read -r -p "Would you like to proceed? [y/N]: " response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
if [[ ! $response =~ ^(yes|y) ]]; then
    echo "Exiting"
    exit 1
fi

# Erase flash
echo "Erasing ESP32 (chip=$CHIP) flash on port $PORT"
esptool.py --port "$PORT" --chip "$CHIP" erase_flash