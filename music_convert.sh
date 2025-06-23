#!/bin/bash

# --- Configuration ---
# Set the source directory for your music collection.
# IMPORTANT: Do not include a trailing slash.
MUSIC_DIR="/path/to/source"

# Set the destination directory for the converted files.
# IMPORTANT: Do not include a trailing slash.
BACKUP_DIR="/path/to/backup"

# Set the FFmpeg audio quality level for OGG Vorbis.
# The scale is -1 to 10, where 10 is the highest quality.
OGG_QUALITY=10

# Regular expression for `find` to filter search-restults for only music files
FIND_REGEX='.+[mp3|wav|flac|aac|m4a|m4b|wma|alac|aiff]$'

# --- Conversion Process ---

# Ensure the backup directory exists
mkdir -p "$BACKUP_DIR"

echo "Starting batch conversion..."
echo "Source:      $MUSIC_DIR"
echo "Destination: $BACKUP_DIR"

# Use 'find' to locate all files, separating them with a NULL character.
find "$MUSIC_DIR" -regex $FIND_REGEX -type f -print0 | while IFS= read -r -d '' input_file; do

    # Construct the output file path.
    relative_path="${input_file#$MUSIC_DIR/}"
    output_file="${BACKUP_DIR}/${relative_path%.*}.ogg"

    # Create the destination directory structure if it doesn't exist.
    mkdir -p "$(dirname "$output_file")"

    # Display the conversion being performed.
    echo "-------------------------------------------"
    echo "Converting: $input_file"

    # Execute the FFmpeg conversion, redirecting stdin from /dev/null
    # to prevent it from consuming the input of the 'while' loop.
    ffmpeg -i "$input_file" -c:a libvorbis -q:a "$OGG_QUALITY" -vn -y -loglevel error "$output_file" < /dev/null

done

echo "-------------------------------------------"
echo "Batch conversion complete!"
