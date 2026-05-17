#!/bin/bash
# rmbg-watch.sh - Watch folder for new images and process automatically
# Usage: rmbg-watch.sh <folder> [options]

FOLDER="${1?Usage: rmbg-watch.sh <folder> [options]}"
shift

RMBG="$(dirname "$0")/../bin/rmbg"

echo "Watching $FOLDER for new images..."

while true; do
    for f in "$FOLDER"/*.png "$FOLDER"/*.jpg "$FOLDER"/*.jpeg; do
        [[ -f "$f" ]] || continue
        [[ "$f" == *"_clean"* ]] && continue

        if [[ ! -f "${f%.*}_clean.png" ]]; then
            echo "Processing: $f"
            "$RMBG" "$f" "$@"
        fi
    done
    sleep 5
done