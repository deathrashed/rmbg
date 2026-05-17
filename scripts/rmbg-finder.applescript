-- rmbg-finder.applescript
-- Finder Services integration for rmbg
-- Install to ~/Library/Services/ or ~/Library/Workflows/Applications/Finder/

on run
    tell application "Finder"
        set selectedItems to selection
        if (count of selectedItems) is 0 then
            display dialog "No files selected" with icon caution
            return
        end if

        set outputFolder to choose folder with prompt "Choose output folder:"

        repeat with anItem in selectedItems
            set inputPath to POSIX path of anItem
            set scriptPath to POSIX path of (path to me)
            set rmbgPath to do shell script "dirname " & quoted form of scriptPath & "/../bin/rmbg"

            do shell script quoted form of rmbgPath & " " & quoted form of inputPath & " -o"

            tell application "Finder"
                reveal POSIX file (outputFolder as text)
            end tell
        end repeat
    end tell
end run