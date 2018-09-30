#!/bin/bash

# The script aims to uninstall a specified brew formula without breaking any shared
# dependencies used by the others.
# Test is OK with Homebrew 1.7.6 on macOS Mojave (10.14.0).
if [ $# -ne 1 ]; then
  echo "Illegal number of parameters. Usage: $0 formula"
  exit 1
fi

if [ -z "$(which brew)" ]; then
  echo "brew: command not found. Please install Homebrew."
  exit 1
fi

FORMULA=$1
if [ -z "$(brew list | sed -n "/^$FORMULA$/p")" ]; then
  echo "$FORMULA is not installed via Homebrew."
  exit 1
fi

echo "Ready to uninstall formula: "
brew list --versions $FORMULA
echo -n "Would you like to continue? (Y/N) " && read ans

if [ ! "$ans" == "Y" ]; then
  exit 0
fi

echo "Uninstalling dependencies..."
brew deps $FORMULA | xargs brew remove --ignore-dependencies
echo "Uninstalling $FORMULA..."
brew uninstall $FORMULA
echo "Reinstalling missing dependencies..."
brew missing | cut -d: -f1 | xargs brew reinstall
echo "Done."

# TODO: Analyse the indirect/indirect dependencies first before running brew remove.
# The solution above removes all the dependencies blindly, which is not ideal since
# many shared formula might be downloaded again.
