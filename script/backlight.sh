#!/bin/bash

# Auto-detect backlight device
DEVICE=$(ls /sys/class/backlight | head -n1)

if [ -z "$DEVICE" ]; then
  echo "No backlight device found"
  exit 1
fi

PATH_BASE="/sys/class/backlight/$DEVICE"
FILE="$PATH_BASE/brightness"
MAX=$(cat "$PATH_BASE/max_brightness")
CUR=$(cat "$FILE")

STEP=$((MAX / 10))

# Set a minimum brightness cap (e.g., 5% of the maximum brightness)
MIN=$((MAX * 5 / 100))

# Ensure MIN is always at least 1, so the screen never turns completely off
[ $MIN -le 0 ] && MIN=1

case "$1" in
  up)
    NEW=$((CUR + STEP))
    [ $NEW -gt $MAX ] && NEW=$MAX
    ;;
  down)
    NEW=$((CUR - STEP))
    # Enforce the minimum cap instead of 0
    [ $NEW -lt $MIN ] && NEW=$MIN
    ;;
  *)
    echo "Usage: $0 up|down"
    exit 1
esac

echo "$NEW" > "$FILE"
