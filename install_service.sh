#!/bin/bash

# --- CONFIGURATION ---
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WATCH_SCRIPT="$PROJECT_DIR/watch.sh"
PLIST_TEMPLATE="$PROJECT_DIR/com.leowuellner.portfolio.watcher.plist.template"
SERVICE_NAME="com.leowuellner.portfolio.watcher"
INSTALL_DIR="$HOME/Library/LaunchAgents"
DEST_PLIST="$INSTALL_DIR/$SERVICE_NAME.plist"
LOG_FILE="$PROJECT_DIR/logs/watcher.log"

echo "--- Installing Portfolio Watcher Service ---"

# 1. Ensure logs directory exists
mkdir -p "$PROJECT_DIR/logs"

# 2. Create the final .plist file from the template
if [ ! -f "$PLIST_TEMPLATE" ]; then
    echo "Error: Template file not found!"
    exit 1
fi

echo "Creating service file at: $DEST_PLIST"
sed -e "s|PATH_PLACEHOLDER_WATCH|$WATCH_SCRIPT|g" \
    -e "s|PATH_PLACEHOLDER_LOG|$LOG_FILE|g" \
    "$PLIST_TEMPLATE" > "$DEST_PLIST"

# 3. Unload old service if exists
launchctl unload "$DEST_PLIST" 2>/dev/null

# 4. Load the new service
echo "Starting service..."
launchctl load "$DEST_PLIST"

echo "✅ Success! The watcher is now running in the background."
echo "It will restart automatically if you reboot."
echo "Logs are located at: $LOG_FILE"
