while true; do
    # Check if a Finder window is open
    if sudo osascript -e 'tell application "Finder" to return (count of windows) > 0' > /dev/null; then
        # If a Finder window is open, kill all ngrok processes
        sudo killall ngrok
        break
    fi
    sleep 1
done

