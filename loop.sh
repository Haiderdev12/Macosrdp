while true; do
    if ! pgrep -x "ngrok" > /dev/null; then
        echo "ngrok is stopped. Restarting..."
        ngrok tcp 3389 &
    fi
    sleep 1
done
