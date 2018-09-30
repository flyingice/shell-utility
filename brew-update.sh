#!/bin/bash

# formula update via Homebrew
BIN=brew
if [ -n "$(which $BIN)" ]; then
  echo "Fetch the newest version of Homebrew from GitHub..."
  brew update
  echo "Upgrade outdated brews..."
  brew upgrade
  echo "Remove old versions of installed formula..."
  brew cleanup -s
  echo "Done."
else
  echo "$BIN: command not found. Please install $BIN."
  exit 1
fi
