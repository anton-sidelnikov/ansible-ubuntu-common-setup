#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to display an error message and exit
function error_exit {
    echo "Error: $1" >&2
    exit 1
}

# Check if root
if [ "$EUID" -ne 0 ]; then
    error_exit "This script must be run as root"
fi

# Check if required parameters are provided
if [ $# -ne 3 ]; then
    error_exit "Usage: $0 <passphrase> <device> <luks_partition>"
fi

passphrase="$1"
device="$2"
luks_partition="$3"

# Function to check if partition size is less than 16MB
function check_partition_size {
    local size_bytes
    size_bytes=$(blockdev --getsize64 "$device")
    local size_mb
    size_mb=$((size_bytes / 1024 / 1024))
    if [ "$size_mb" -lt 16 ]; then
        echo "Partition size is less than 16MB. Using LUKS version 1."
        return 0
    else
        echo "Partition size is 16MB or greater. Using LUKS version 2."
        return 1
    fi
}

# Check partition size
if check_partition_size; then
    # Encrypt partition using LUKS version 1
    cryptsetup luksFormat --type luks1 "$device" <<< "$passphrase" || error_exit "Failed to encrypt partition with LUKS version 1"
else
    # Encrypt partition using LUKS version 2
    cryptsetup luksFormat "$device" <<< "$passphrase" || error_exit "Failed to encrypt partition with LUKS"
fi

# Open encrypted partition
if ! cryptsetup luksOpen "$device" "$luks_partition" <<< "$passphrase"; then
    error_exit "Failed to open encrypted partition"
fi
