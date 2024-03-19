#!/bin/bash

# Define source and destination directories
source_dir_records="/store/ariel/events/records/"
destination_dir_records="/tmp/"
source_dir_payloads="/store/ariel/events/payloads/"
destination_dir_payloads="/tmp/"


log_forwarding() {
# Calculate the date x days ago (for example, I have defined 7 days ago)
x_days_ago=$(date -d "7 days ago" +%Y/%m/%d)

# Function to create directories if they don't exist
create_dirs() {
    local dir_path=$1
    if [ ! -d "$dir_path" ]; then
        mkdir -p "$dir_path"
    fi
}

# Function to copy logs older than x days to temporary location
move_logs() {
    local src="$1"
    local dest="$2"

    for entry in "$src"/*; do
        if [ -f "$entry" ]; then
            # Get the date of the log file
            log_date=$(date -r "$entry" +%Y/%m/%d)
            if [[ "$log_date" < "$x_days_ago" ]]; then
                # Create directory structure in temp directory if it doesn't exist
                dest_dir="$dest${entry#$source_dir}"
                create_dirs "$(dirname "$dest_dir")"
                # Copy the log file to temporary location
                mv "$entry" "$dest_dir"
            fi
        elif [ -d "$entry" ]; then
            # Recursively copy logs in subdirectories
            move_logs "$entry" "$dest"
        fi
    done
}

# script to copy files and folders
copy_logs "$1" "$2"
}

#main script to move payloads and records
log_forwarding "$source_dir_records" "$destination_dir_records"
log_forwarding "$source_dir_payloads" "$destination_dir_payloads"
