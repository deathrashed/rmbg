#!/usr/bin/env bash
set -euo pipefail

RMBG="/Users/rd/Scripts/Riley/rmbg/bin/rmbg"
MAGICK="/opt/homebrew/bin/magick"
LOG="/tmp/rmbg-keyboard-maestro.log"
FALLBACK_DIR="$HOME/Downloads/rmbg-output"

: > "$LOG"

notify() {
    /usr/bin/osascript - "$1" <<'APPLESCRIPT'
on run argv
    display notification (item 1 of argv) with title "rmbg"
end run
APPLESCRIPT
}

selection=$(/usr/bin/osascript <<'APPLESCRIPT'
tell application "Finder"
    set selectedItems to selection
    if selectedItems is {} then return ""
    set output to ""
    repeat with anItem in selectedItems
        set output to output & POSIX path of (anItem as alias) & linefeed
    end repeat
    return output
end tell
APPLESCRIPT
)

if [[ -z "$selection" ]]; then
    notify "Select one or more images or folders in Finder first."
    exit 0
fi

# Helper to verify write access
can_write_dir() {
    local dir="$1"
    local probe="$dir/.rmbg-write-test-$$"
    if : > "$probe" 2>/dev/null; then
        rm -f "$probe"
        return 0
    fi
    return 1
}

unique_output_path() {
    local dir="$1"
    local stem="$2"
    local out="$dir/${stem}_clean.png"
    local n=2
    while [[ -e "$out" ]]; do
        out="$dir/${stem}_clean $n.png"
        n=$((n + 1))
    done
    printf '%s\n' "$out"
}

process_file() {
    local src="$1"
    local dir base stem ext lower target_dir out work input rmbg_result

    [[ -f "$src" ]] || return 0
    base="$(basename "$src")"
    stem="${base%.*}"
    ext="${base##*.}"
    lower="$(printf '%s' "$ext" | tr '[:upper:]' '[:lower:]')"

    case "$lower" in
        png|jpg|jpeg|gif|icns) ;;
        *) echo "Skipped unsupported file: $src" >> "$LOG"; skipped=$((skipped + 1)); return 0 ;;
    esac

    dir="$(dirname "$src")"
    if can_write_dir "$dir"; then
        target_dir="$dir"
    else
        target_dir="$FALLBACK_DIR"
        mkdir -p "$target_dir"
        fallback_used=1
    fi

    out="$(unique_output_path "$target_dir" "$stem")"
    work="$(mktemp -d /tmp/rmbg-km.XXXXXX)" || return 1
    input="$work/$base"
    rmbg_result="$work/${stem}_clean.png"

    if ! cp "$src" "$input" >> "$LOG" 2>&1; then
        echo "Failed to copy source: $src" >> "$LOG"
        rm -rf "$work"
        failed=$((failed + 1))
        return 0
    fi

    # Run the core rmbg tool in smart logo mode with antialiasing
    if "$RMBG" -L -a "$input" >> "$LOG" 2>&1 && [[ -f "$rmbg_result" ]]; then
        if mv "$rmbg_result" "$out" >> "$LOG" 2>&1; then
            converted=$((converted + 1))
            echo "Wrote: $out" >> "$LOG"
        else
            echo "Failed to write output: $out" >> "$LOG"
            failed=$((failed + 1))
        fi
    else
        echo "Failed to process: $src" >> "$LOG"
        failed=$((failed + 1))
    fi

    rm -rf "$work"
}

converted=0
skipped=0
failed=0
fallback_used=0

while IFS= read -r item; do
    [[ -z "$item" ]] && continue

    if [[ -d "$item" ]]; then
        while IFS= read -r file; do
            process_file "$file"
        done < <(/usr/bin/find "$item" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.icns' \) 2>>"$LOG")
    else
        process_file "$item"
    fi
done <<< "$selection"

message="Converted $converted image(s)."
if [[ "$fallback_used" -eq 1 ]]; then
    message="$message Protected-folder output went to Downloads/rmbg-output."
fi
if [[ "$skipped" -gt 0 || "$failed" -gt 0 ]]; then
    message="$message Skipped: $skipped. Failed: $failed."
fi

notify "$message"

if [[ "$failed" -gt 0 ]]; then
    tail -80 "$LOG" >&2
    exit 1
fi
