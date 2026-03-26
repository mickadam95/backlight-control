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

case "$1" in
  up)
    NEW=$((CUR + STEP))
    [ $NEW -gt $MAX ] && NEW=$MAX
    ;;
  down)
    NEW=$((CUR - STEP))
    [ $NEW -lt 0 ] && NEW=0
    ;;
  *)
    echo "Usage: $0 up|down"
    exit 1
esac

echo "$NEW" > "$FILE"
