while true; do
    # Check if the screen is locked
    if /usr/libexec/PlistBuddy -c "print :IOConsoleUsers:0:CGSSessionScreenIsLocked" /dev/stdin 2>/dev/null <<< "$(ioreg -n Root -d1 -a)" > /dev/null; then
        # If the screen is locked, kill all ngrok processes
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
