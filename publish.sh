#!/bin/bash

# --- CONFIGURATION ---
# Path to your web project (Change this to your actual path)
# Path to your web project (Change this to your actual path)
PROJECT_DIR="/Users/leo/Code/leowuellner.com"

# Log file to debug if Lightroom actually triggers it
LOG_FILE="$PROJECT_DIR/logs/publish.log"

# --- EXECUTION ---
echo "--- Starting Publish: $(date) ---" >> "$LOG_FILE"

# Navigate to project directory
cd "$PROJECT_DIR" || { echo "Failed to cd to $PROJECT_DIR" >> "$LOG_FILE"; exit 1; }

# Add all new changes (new folders/images from Lightroom)
git add . >> "$LOG_FILE" 2>&1

# Commit with a timestamp
git commit -m "Portfolio Update: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE" 2>&1

# Push to GitHub (Vercel will see this and auto-deploy)
git push origin main >> "$LOG_FILE" 2>&1

echo "--- Publish Complete ---" >> "$LOG_FILE"