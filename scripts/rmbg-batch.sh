#!/bin/bash
# rmbg-batch.sh - Process multiple folders in sequence
# Usage: rmbg-batch.sh folder1 folder2 folder3 ...

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RMBG="$SCRIPT_DIR/../bin/rmbg"

for folder in "$@"; do
    if [[ -d "$folder" ]]; then
        echo "Processing: $folder"
        "$RMBG" "$folder" -R -o
        echo "---"
    else
        echo "Skipping (not a folder): $folder"
    fi
done

echo "All folders processed!"