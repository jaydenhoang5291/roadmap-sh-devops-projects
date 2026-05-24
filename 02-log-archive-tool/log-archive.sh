#!/bin/bash

# Get the log directory from the first command-line argument.
LOG_DIR=$1

# Stop if the user did not provide a log directory.
if [ -z "$LOG_DIR" ]; then
    echo "Usage: ./log-archive.sh <log-directory>"
    exit 1
fi

# Stop if the provided path is not an existing directory.
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory '$LOG_DIR' does not exist."
    exit 1
fi

# Create timestamps for the archive file name and the human-readable log entry.
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Build the archive file name required by the project.
ARCHIVE_NAME="logs_archive_${TIMESTAMP}.tar.gz"

# Create a directory to store archive files if it does not already exist.
ARCHIVE_DIR="archives"
mkdir -p "$ARCHIVE_DIR"

# Build full paths for the archive file and archive history log.
ARCHIVE_PATH="$ARCHIVE_DIR/$ARCHIVE_NAME"
LOG_FILE="$ARCHIVE_DIR/archive.log"

# Compress the log directory into a tar.gz archive.
tar -czf "$ARCHIVE_PATH" "$LOG_DIR"

# Record the archive only if tar completed successfully.
if [ $? -eq 0 ]; then
    echo "$LOG_TIMESTAMP Archived '$LOG_DIR' to '$ARCHIVE_PATH'" >> "$LOG_FILE"
    echo "Archive created: $ARCHIVE_PATH"
    echo "Archive log updated: $LOG_FILE"
else
    echo "Error: Failed to create archive."
    exit 1
fi
