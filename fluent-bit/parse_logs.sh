#!/bin/bash -e

################################################################################
# Helpers
################################################################################

TMP_FILE=tmp.log

function cleanup() {
    # Remove the temporary file
    rm -f "$TMP_FILE"
}

# Echo the log MESSAGE and preserve escape codes.
#
# Args:
#   $1: The log message to echo.
function echo_message() {
    # Remove the wrapped "" from the message.
    message=$(echo "$message" | sed 's/^"\(.*\)"$/\1/')

    echo -e "$message"
}

################################################################################
# Main script
################################################################################

USAGE="""Description:
    Parse the logs from a given systemd journal log file from fluent-bit.

Usage:
    $0 -f <log_file> [-u <unit_name>] [-n <num_lines_to_include>]

Options:
    -f    Required argument that specifies the log file to parse.
    [-u]  Optional argument that specifies the unit name to filter logs.
    [-n]  Optional argument that specifies the number of lines to include from the log file.
    [-h]  Show this message.

Examples:
    $0 -f systemd.log
    $0 -f systemd.log -u my-service
    $0 -f systemd.log -n 100
    $0 -f systemd.log -u my-service -n 100
"""

LOG_FILE=
UNIT_NAME=
NUM_LINES=

# Parse the arguments
while getopts ":f:u:n:h" opt; do
    case $opt in
    f)
        LOG_FILE=$OPTARG
        ;;
    u)
        UNIT_NAME=$OPTARG
        ;;
    n)
        NUM_LINES=$OPTARG
        ;;
    h)
        echo "$USAGE"
        exit 0
        ;;
    \?)
        echo "Invalid option: $OPTARG" 1>&2
        exit 1
        ;;
    :)
        echo "Option -$OPTARG requires an argument." 1>&2
        exit 1
        ;;
    esac
done

# Check if the file exists.
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' not found!"
    echo ""
    echo "$USAGE"
    exit 1
fi

# Cleanup the temporary file on exit.
trap cleanup EXIT

# Check if the number of lines to include is provided.
if [ ! -z "$NUM_LINES" ]; then
    # Get the last N lines from the log file.
    tail -n "$NUM_LINES" "$LOG_FILE" >"$TMP_FILE"
    LOG_FILE="$TMP_FILE"
fi

# Parse.
if [ -z "$UNIT_NAME" ]; then
    # Parse the log file and extract MESSAGE fields
    jq -r '.MESSAGE' "$LOG_FILE" | while IFS= read -r message; do
        echo_message "$message"
    done
else
    # Parse and filter logs
    jq --arg unit "$UNIT_NAME" '
  select(._SYSTEMD_UNIT == $unit) | .MESSAGE
' "$LOG_FILE" | while IFS= read -r message; do
        echo_message "$message"
    done
fi
