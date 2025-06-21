#!/bin/bash

# --- Configuration ---
# Ensure you use absolute paths

# Set the source directory for your music collection.
# IMPORTANT: Do not include a trailing slash.
MUSIC_DIR="/path/to/source"

# Set the destination directory for the converted files.
# IMPORTANT: Do not include a trailing slash.
BACKUP_DIR="/path/to/backup"

# Set the FFmpeg audio quality level for OGG Vorbis.
# The scale is -1 to 10, where 10 is the highest quality.
OGG_QUALITY=10

# --- Conversion Process ---

# Ensure the backup directory exists.
mkdir -p "$BACKUP_DIR"

# Optional: Log file for cron job output.
LOG_FILE="/path/to/logfile.log"

echo "-------------------------------------------" | tee -a "$LOG_FILE"
echo "Starting incremental backup scan on $(date)" | tee -a "$LOG_FILE"
echo "Source:      $MUSIC_DIR" | tee -a "$LOG_FILE"
echo "Destination: $BACKUP_DIR" | tee -a "$LOG_FILE"

# Use 'find' to locate all files, separating them with a NULL character.
find "$MUSIC_DIR" -type f -print0 | while IFS= read -r -d '' input_file; do

    # Construct the output file path.
    relative_path="${input_file#$MUSIC_DIR/}"
    output_file="${BACKUP_DIR}/${relative_path%.*}.ogg"

    # --- INCREMENTAL CHECK ---
    # Check if the output file does NOT exist, OR if the input file is newer than the output file.
    if [ ! -f "$output_file" ] || [ "$input_file" -nt "$output_file" ]; then

        # Create the destination directory structure if it doesn't exist.
        mkdir -p "$(dirname "$output_file")"

        # Display and log the conversion being performed.
        echo "Converting: $input_file" | tee -a "$LOG_FILE"

        # Execute the FFmpeg conversion, redirecting stdin from /dev/null.
        ffmpeg -i "$input_file" -c:a libvorbis -q:a "$OGG_QUALITY" -vn -y -loglevel error "$output_file" < /dev/null

    fi

done

echo "Incremental backup scan complete on $(date)" | tee -a "$LOG_FILE"
echo "-------------------------------------------" | tee -a "$LOG_FILE"
