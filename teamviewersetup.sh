# Set the username
username=$1

# Download the file from Google Drive
file_id="1saqhkHbhDcz4uF66asQVu6rYsYsvPCne"
destination="/Users/$username/Desktop/TeamViewerHost.app"
sudo cd /Users/$username/Desktop/
sudo wget --no-check-certificate 'https://docs.google.com/uc?export=download&id='$file_id

# Set the screensaver idle time to 0
sudo defaults write h/Library/Preferences/com.apple.screensaver loginWindowIdleTime 0
