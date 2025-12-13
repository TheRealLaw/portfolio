#!/bin/bash

echo "--- Starting Portfolio Setup ---"

# 1. Check for Homebrew (macOS package manager)
if ! command -v brew &> /dev/null; then
    echo "Info: Homebrew not found. You might need it to install Node/Git easily."
    # We won't auto-install Brew as it's a big system change, but we warn.
fi

# 2. Check/Install Node.js
if ! command -v node &> /dev/null; then
    echo "Installing Node.js via Homebrew..."
    brew install node
else
    echo "✓ Node.js is installed ($(node -v))"
fi

# 3. Check/Install Git
if ! command -v git &> /dev/null; then
    echo "Installing Git..."
    brew install git
else
    echo "✓ Git is installed"
fi

# 4. Check/Install GitHub CLI (useful for auth)
if ! command -v gh &> /dev/null; then
    echo "Installing GitHub CLI (gh)..."
    brew install gh
else
    echo "✓ GitHub CLI (gh) is installed"
fi

# 5. Install Project Dependencies
echo "Installing project dependencies via npm..."
npm install

# 6. Make scripts executable
chmod +x publish.sh
chmod +x setup.sh

echo "--- Setup Complete! ---"
echo "You can now run 'npm run dev' to start the site."
echo "If you need to log in to GitHub, run 'gh auth login'."
