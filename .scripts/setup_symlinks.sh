#!/bin/bash
DEV_DIR="$HOME/Development"
SYMLINK="/repos"

# Check if dev directory exists
if [ ! -d "$DEV_DIR" ]; then
	echo "Development directory does not exist at $DEV_DIR. Creating now."
	mkdir -p "$DEV_DIR"
fi

# Creating symlink
if [ -L "$SYMLINK" ]; then
	echo "Symlink already exists: $SYMLINK"
else
	sudo ln -s "$DEV_DIR" "$SYMLINK"
	echo "Symlink created: $SYMLINK -> $DEV_DIR"
fi

