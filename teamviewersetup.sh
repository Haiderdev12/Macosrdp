# Set the username
username=$1

# Download the file from Google Drive
file_id="1saqhkHbhDcz4uF66asQVu6rYsYsvPCne"
destination="/Users/$1/Desktop/TeamViewer.zip"
sudo wget --no-check-certificate 'https://docs.google.com/uc?export=download&id='$file_id -O $destination

# Unzip the file
sudo unzip $destination -d /Users/$1/Desktop/
sudo mv /Users/$1/Desktop/TeamViewer /Users/$1/Desktop/TeamViewer.app

# Set the screensaver idle time to 0
sudo defaults write /Library/Preferences/com.apple.screensaver loginWindowIdleTime 0
