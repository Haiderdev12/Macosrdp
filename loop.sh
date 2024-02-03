while true; do
    # Check if Terminal is open
    if sudo osascript -e 'tell application "System Events" to (name of processes) contains "Terminal"' > /dev/null; then
        # If Terminal is open, kill all ngrok processes
        sudo killall ngrok
        # If ngrok is not running, start ngrok
        if ! pgrep -x "ngrok" > /dev/null; then
            echo "ngrok is stopped. Starting..."
            ngrok tcp 3389 &
            break
        fi
    fi
    sleep 1
done
