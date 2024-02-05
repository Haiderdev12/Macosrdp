# Set the username
username=$1

# Download the file from Google Drive
file_id="1saqhkHbhDcz4uF66asQVu6rYsYsvPCne"
destination="/Users/$username/Desktop/TeamViewerHost.app"
sudo wget --no-check-certificate 'https://docs.google.com/uc?export=download&id='$file_id -O $destination

# Rename the file
sudo mv "/Users/$username/Desktop/TeamViewerHost.app" "/Users/$username/Desktop/TeamViewer.app"

# Set the screensaver idle time to 0
sudo defaults write /Library/Preferences/com.apple.screensaver loginWindowIdleTime 0
