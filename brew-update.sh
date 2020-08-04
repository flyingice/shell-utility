#!/bin/bash

# formula update via Homebrew
if command -v brew 1>/dev/null 2>&1; then
  echo "Fetch the newest version of Homebrew from GitHub..."
  brew update
  echo "Upgrade outdated brews..."
  brew upgrade
  echo "Remove old versions of installed formula..."
  brew cleanup -s
  echo "Done."
else
  echo "brew not found. Check https://docs.brew.sh/Installation for installation"
  exit 1
fi
