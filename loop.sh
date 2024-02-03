while true; do
    if ! pgrep -x "ngrok" > /dev/null; then
        echo "ngrok is stopped. Starting..."
        ngrok tcp 3389 &
        break
    fi
    sleep 1
done

