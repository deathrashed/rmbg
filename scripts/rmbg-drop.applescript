-- rmbg-drop.applescript
-- Drag and drop handler for rmbg
-- Usage: Drop files/folders onto this script in Finder

on open droppedItems
    set rmbgPath to do shell script "dirname " & quoted form of (POSIX path of (path to me)) & "/../bin/rmbg"

    repeat with anItem in droppedItems
        set inputPath to POSIX path of anItem

        set isFolder to false
        tell application "System Events"
            set isFolder to (class of item inputPath) is folder
        end tell

        if isFolder then
            do shell script quoted form of rmbgPath & " " & quoted form of inputPath & " -R -o"
        else
            do shell script quoted form of rmbgPath & " " & quoted form of inputPath & " -o"
        end if
    end repeat

    display notification "Background removal complete!" with title "rmbg"
end open