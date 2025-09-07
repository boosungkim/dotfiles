#!/usr/bin/env bash
set -euo pipefail

DEV_DIR="${DEV_DIR:-$HOME/Development}"
NAME="repos"
SYMLINK="/$NAME"
OS="$(uname -s)"

cd ~
mkdir -p "$DEV_DIR"

case "$OS" in
  Darwin)
    # macOS: create a synthetic entry so /repos points to $DEV_DIR
    # ensure absolute path
    case "$DEV_DIR" in /*) DEV_ABS="$DEV_DIR" ;; *) DEV_ABS="$HOME/${DEV_DIR#~/}" ;; esac

    tmp="$(mktemp)"
    if [ -f /etc/synthetic.conf ]; then
      # remove any existing line for 'repos' (tab or spaces), keep others
      sudo sed -E "/^${NAME}[[:space:]]/d" /etc/synthetic.conf | sudo tee "$tmp" >/dev/null
      printf '%s\t%s\n' "$NAME" "$DEV_ABS" | sudo tee -a "$tmp" >/dev/null
      sudo mv "$tmp" /etc/synthetic.conf
    else
      printf '%s\t%s\n' "$NAME" "$DEV_ABS" | sudo tee /etc/synthetic.conf >/dev/null
      rm -f "$tmp"
    fi

    # stitch (or reboot if this fails)
    if ! sudo /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t; then
      echo "Note: reboot to apply /etc/synthetic.conf."
    fi

    if [ -d "$SYMLINK" ]; then
      echo "$SYMLINK now points to $DEV_ABS"
    else
      echo "Failed to create $SYMLINK; check /etc/synthetic.conf" >&2
      exit 1
    fi
    ;;
  Linux)
    # Linux: regular symlink at /repos
    if [ -e "$SYMLINK" ] && [ ! -L "$SYMLINK" ]; then
      echo "Path exists and is not a symlink: $SYMLINK" >&2
      exit 1
    fi
    sudo ln -sfn "$DEV_DIR" "$SYMLINK"
    echo "Symlink created: $SYMLINK -> $DEV_DIR"
    ;;
  *)
    echo "Unsupported OS: $OS" >&2
    exit 2
    ;;
esac

# sanity check
if [ -d "$SYMLINK" ]; then
  cd "$SYMLINK" && pwd
fi

