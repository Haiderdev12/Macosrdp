while true; do
    # Check if a Finder window is open
    if osascript -e 'tell application "Finder" to if window 1 exists then return true else return false end if' > /dev/null; then
        # If a Finder window is open, kill all ngrok processes
        sudo killall ngrok
        break
    fi
    sleep 1
done
