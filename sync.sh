#!/bin/bash

# --- CONFIGURATION ---
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- EXECUTION ---
echo "--- Starting Sync: $(date) ---"

# Navigate to project directory
cd "$PROJECT_DIR" || { echo "Failed to cd to $PROJECT_DIR"; exit 1; }

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  You have uncommitted changes."
    echo "Please commit or stash them before syncing to avoid conflicts."
    exit 1
fi

# Pull latest changes
echo "Pulling latest changes from GitHub..."
git pull --rebase origin main

if [ $? -eq 0 ]; then
    echo "✅ Sync Complete. You are up to date."
else
    echo "❌ Sync Failed. Please check git status."
    exit 1
fi
