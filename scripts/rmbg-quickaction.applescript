on run {input, parameters}
    set rmbgPath to "/Users/rd/Scripts/Riley/rmbg/bin/rmbg"
    
    repeat with anItem in input
        set inputPath to POSIX path of anItem
        
        set isFolder to false
        tell application "System Events"
            set isFolder to (class of item inputPath) is folder
        end tell
        
        try
            if isFolder then
                set result to do shell script rmbgPath & " " & quoted form of inputPath & " -R 2>&1"
            else
                set result to do shell script rmbgPath & " " & quoted form of inputPath & " 2>&1"
            end if
            log result
        on error errMsg
            log errMsg
        end try
    end repeat
    
    return input
end run