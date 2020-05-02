#!/bin/bash
# Warning: This file is managed by puppet
# Wrapper script for smartctl
# Runs the specified test on the specified device

SMARTCTL_PATH=/usr/sbin/smartctl
SCRIPT_NAME=$1

_print_help() {
    echo "Wrapper for smartctl (requires smartctl to be installed)"
    echo "Usage: $SCRIPT_NAME [-h|--help|help] SCAN_TYPE [DEVICE]"
    echo "For the available scan types, please consult man smartctl(8)"
    echo "If no device is specified, all possible devices are retrieved with smartctl --scan and checks are launched"
}

if [[ $# -eq 0 || $# -gt 2 ]]; then
    _print_help
    exit 1
fi

if [[ "$1" == "help" || "$1" == "-h" || "$1" == "--help" ]]; then
    _print_help
    exit 0
fi

if [[ -x "$SMARTCTL_PATH" ]]; then
    if [[ $# -lt 2 ]]; then

        # Exception for HP Smart Array CCISS driver
        if [[ -d /dev/cciss/ ]]; then
            "$SMARTCTL_PATH" --test="$1" -d cciss,0 /dev/cciss/c0d0
            exit 0
        else
            # retrieve all available devices
            devices=$( "$SMARTCTL_PATH" --scan | cut -d' ' -f1 )
        fi

        # launch test on each device
        while read -r line; do
            "$SMARTCTL_PATH" --test="$1" "$line"
        done <<< "$devices"
    else
	# launch test on single device
        "$SMARTCTL_PATH" --test="$1" "$2"
    fi
else
    echo "[$0] Error: could not find $SMARTCTL_PATH"
    exit 1
fi
