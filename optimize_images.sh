#!/bin/bash

# Directory to scan
TARGET_DIR="src/content/portfolio"
BACKUP_DIR="src/content/_ORIGINALS"
MAX_SIZE=2500

echo "Scanning $TARGET_DIR for images larger than ${MAX_SIZE}px..."

# Find images (jpg, jpeg, png, webp) - case insensitive
find "$TARGET_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | while read FILE; do
    # Get dimensions
    # sips output format: "  pixelWidth: 4000"
    WIDTH=$(sips -g pixelWidth "$FILE" 2>/dev/null | awk '/pixelWidth/ {print $2}')
    HEIGHT=$(sips -g pixelHeight "$FILE" 2>/dev/null | awk '/pixelHeight/ {print $2}')

    # Skip if we couldn't read dimensions
    if [ -z "$WIDTH" ] || [ -z "$HEIGHT" ]; then
        continue
    fi

    # Check if either dimension exceeds MAX_SIZE
    if [ "$WIDTH" -gt "$MAX_SIZE" ] || [ "$HEIGHT" -gt "$MAX_SIZE" ]; then
        echo "Optimizing: $FILE (${WIDTH}x${HEIGHT})"
        
        # Optimize using sips
        # -Z 2500: Resample keeping aspect ratio so max dimension is 2500
        # -s format jpeg: Ensure it's a jpeg (useful if input is png/webp, but note: this might overwrite extension content without changing name if not careful. Sips usually handles in-place for same format. For different format we might want to rename, but for now let's stick to simple resizing primarily.)
        # Actually proper conversion from png to jpg requires changing extension or sips might write jpg data to .png file which is messy.
        # Let's just resize and keep format for now, OR valid requirement "jpeg, 80%".
        # If user wants jpeg specifically, we should probably stick to .jpg files for safety or handle renaming.
        # Let's stick to resizing and quality setting, and forcing jpeg format options. 
        # If it is a PNG, converting to JPEG 80% is good for photos.
        
        # Backup logic
        RELATIVE_PATH="${FILE#$TARGET_DIR/}"
        BACKUP_FILE="$BACKUP_DIR/$RELATIVE_PATH"
        BACKUP_DIR_PATH=$(dirname "$BACKUP_FILE")
        
        mkdir -p "$BACKUP_DIR_PATH"
        mv "$FILE" "$BACKUP_FILE"
        echo "  -> Moved original to $BACKUP_FILE"

        # Optimization (read from backup, write to original location)
        
        # EXTENSION handling
        EXT="${FILE##*.}"
        EXT_LOWER=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')
        
        if [ "$EXT_LOWER" == "png" ] || [ "$EXT_LOWER" == "webp" ]; then
             # Create new jpg filename in TARGET location
             NEW_FILE="${FILE%.*}.jpg"
             sips -Z "$MAX_SIZE" -s format jpeg -s formatOptions 80 -s dpiHeight 72 -s dpiWidth 72 "$BACKUP_FILE" --out "$NEW_FILE" > /dev/null
             echo "  -> Created optimized $NEW_FILE"
        else
             # Process back to original location
             sips -Z "$MAX_SIZE" -s format jpeg -s formatOptions 80 -s dpiHeight 72 -s dpiWidth 72 "$BACKUP_FILE" --out "$FILE" > /dev/null
             echo "  -> Created optimized $FILE"
        fi
    fi
done

echo "Optimization complete."
