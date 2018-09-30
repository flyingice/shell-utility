#!/bin/bash

# update all the 3rd party packages installed via pip install
BIN='pip'
if [ -n "$(which $BIN)" ]; then
  echo "Start updating packages..."
  $BIN list --outdated | awk 'NR>2 {print $1}' | xargs -n1 $BIN install --upgrade && echo "Done."
else
  echo "$BIN: command not found. Please install $BIN."
  exit 1
fi
