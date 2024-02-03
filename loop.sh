while true; do
    # Check if the screen is locked
    if /usr/libexec/PlistBuddy -c "print :IOConsoleUsers:0:CGSSessionScreenIsLocked" /dev/stdin 2>/dev/null <<< "$(ioreg -n Root -d1 -a)" > /dev/null; then
        # If the screen is locked, kill all ngrok processes
        sudo killall ngrok
        break
    fi
    sleep 1
done
