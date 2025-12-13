#!/bin/bash

# --- CONFIGURATION ---
# PROJECT_DIR is where this script is located
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# WATCH_DIR is the portfolio content folder
WATCH_DIR="$PROJECT_DIR/src/content/portfolio"

echo "--- Portfolio Watcher Started ---"
echo "Project:  $PROJECT_DIR"
echo "Watching: $WATCH_DIR"

# --- HELPER: PUBLISH FUNCTION ---
run_publish() {
    echo "[$(date '+%H:%M:%S')] Change detected. Running publish..."
    # Call the existing publish script to reuse its safety logic (commit/pull/push)
    "$PROJECT_DIR/publish.sh"
    echo "[$(date '+%H:%M:%S')] Cycle complete."
}

# --- MAIN LOOP ---
if ! command -v fswatch &> /dev/null; then
    echo "Info: 'fswatch' is not installed. Using simple polling (5s interval)."
    echo "To install fswatch for better performance: brew install fswatch"
    
    while true; do
        cd "$PROJECT_ROOT" 2>/dev/null
        # Check if there are changes to the content folder
        if [[ -n $(git status --porcelain "$WATCH_DIR") ]]; then
            run_publish
        fi
        sleep 5
    done
else
    echo "Success: 'fswatch' found. Using event-driven monitoring."
    # Watch for changes, identifying distinct batch events
    fswatch -o "$WATCH_DIR" | while read num; do
        # Wait a moment for Lightroom to finish writing a batch of files
        sleep 2
        
        # Check if there are actual git changes (avoids false positives)
        if [[ -n $(git status --porcelain "$WATCH_DIR") ]]; then
            run_publish
        fi
    done
fi
