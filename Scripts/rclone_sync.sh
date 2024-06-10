#!/bin/bash

# Sleep for a specified time (e.g., 300 seconds = 5 minutes)
sleep 600


# Define the backup source and destination
SOURCE="/home/charuka/Calibre Library"
DESTINATION="r2:backup/calibre"
CHECKSUM_FILE="/home/charuka/checkSum/checksum_file.txt"
BACKUP_NAME="backup_$(date +%Y%m%d%H%M%S)"

# Generate the current checksum of the folder structure
CURRENT_CHECKSUM=$(find "$SOURCE" -type f -exec md5sum {} + | sort | md5sum | awk '{ print $1 }')

# Read the previous checksum
if [ -f "$CHECKSUM_FILE" ]; then
    PREVIOUS_CHECKSUM=$(cat "$CHECKSUM_FILE")
else
    PREVIOUS_CHECKSUM=""
fi

# Compare checksums and perform the backup if they differ
if [ "$CURRENT_CHECKSUM" != "$PREVIOUS_CHECKSUM" ]; then
    # Perform the backup using rclone
    rclone copy "$SOURCE" "$DESTINATION/$BACKUP_NAME"

    # Update the checksum file with the current checksum
    echo "$CURRENT_CHECKSUM" > "$CHECKSUM_FILE"

    # Remove older backups, keeping only the two most recent ones
    rclone lsf "$DESTINATION" | sort -r | sed -e '1,4d' | while read -r folder; do
        rclone purge "$DESTINATION/$folder"
    done
fi


