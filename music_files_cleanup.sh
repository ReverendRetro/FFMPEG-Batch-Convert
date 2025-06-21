#!/bin/bash

# --- Configuration ---
# These paths MUST match the paths in your main conversion script.
MUSIC_DIR="/path/to/source"
BACKUP_DIR="/path/to/backup"
LOG_FILE="/path/to/cleanup_music.log"

# Define the list of possible source audio extensions.
# This should match the extensions in the main script's find command.
POSSIBLE_EXTENSIONS=(flac wav mp3 m4a ogg aiff aif wma aac ape opus)

echo "Starting orphan file cleanup..." | tee -a "$LOG_FILE"

# Find all .ogg files in the backup directory, separated by NULL characters.
find "$BACKUP_DIR" -type f -iname "*.ogg" -print0 | while IFS= read -r -d '' ogg_file; do
    
    # Figure out the potential source file path, but without the extension.
    # e.g., /backup/Artist/Album/Song.ogg -> /music/Artist/Album/Song
    relative_path="${ogg_file#$BACKUP_DIR/}"
    source_base_path="${MUSIC_DIR}/${relative_path%.*}"

    source_exists=false
    # Check if a source file exists with ANY of the possible extensions.
    for ext in "${POSSIBLE_EXTENSIONS[@]}"; do
        if [ -f "${source_base_path}.${ext}" ]; then
            source_exists=true
            break # Found a source file, so this .ogg is NOT an orphan. Stop checking.
        fi
    done

    # If, after checking all extensions, no source file was found, it's an orphan.
    if [ "$source_exists" = false ]; then
        echo "Removing orphan file: $ogg_file" | tee -a "$LOG_FILE"
        rm "$ogg_file"
    fi
done

# Finally, clean up any empty directories left behind in the backup.
echo "Cleaning up empty directories..." | tee -a "$LOG_FILE"
find "$BACKUP_DIR" -type d -empty -delete

echo "Orphan cleanup complete." | tee -a "$LOG_FILE"
