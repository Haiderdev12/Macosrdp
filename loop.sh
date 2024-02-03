while true; do
    if ! pgrep -x "ngrok" > /dev/null; then
        echo "ngrok is stopped. Restarting..."
        ngrok authtoken $1
        ngrok tcp 3389 &
    fi
    sleep 1
done
