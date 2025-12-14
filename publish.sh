#!/bin/bash

# --- CONFIGURATION ---
# Path to your web project (Automatically detected)
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Log file to debug if Lightroom actually triggers it
LOG_FILE="$PROJECT_DIR/logs/publish.log"

# --- EXECUTION ---
# Increase git buffer size for large image uploads (500MB)
git config http.postBuffer 524288000

echo "--- Starting Publish: $(date) ---" >> "$LOG_FILE"

# Navigate to project directory
cd "$PROJECT_DIR" || { echo "Failed to cd to $PROJECT_DIR" >> "$LOG_FILE"; exit 1; }



# Optimize images before commiting
echo "--- Optimizing Images ---" >> "$LOG_FILE"
npm run optimize >> "$LOG_FILE" 2>&1

# Add all new changes (new folders/images from Lightroom)
git add . >> "$LOG_FILE" 2>&1

# Commit with a timestamp
git commit -m "Portfolio Update: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE" 2>&1

# Prevent conflicts: Pull latest changes first (rebase local commits on top)
echo "--- specific sync step start ---" >> "$LOG_FILE"
git pull --rebase origin main >> "$LOG_FILE" 2>&1
if [ $? -ne 0 ]; then
    echo "❌ CRITICAL ERROR: Git pull failed. Unresolvable conflicts." >> "$LOG_FILE"
    echo "Please resolve conflicts manually and then run 'git push'." >> "$LOG_FILE"
    exit 1
fi
echo "--- specific sync step end ---" >> "$LOG_FILE"

# Push to GitHub (Vercel will see this and auto-deploy)
git push origin main >> "$LOG_FILE" 2>&1

echo "--- Publish Complete ---" >> "$LOG_FILE"