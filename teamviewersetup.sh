# Download the file from Google Drive
file_id="1saqhkHbhDcz4uF66asQVu6rYsYsvPCne"
destination="/Users/$1/Desktop/TeamViewer.zip"
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id='$file_id -O $destination

# Unzip the file
unzip $destination -d /Users/$1/Desktop/
mv /Users/$1/Desktop/TeamViewer /Users/$1/Desktop/TeamViewer.app

# Open the app
open /Users/$1/Desktop/TeamViewer.app

# Set the screensaver idle time to 0
sudo defaults write /Library/Preferences/com.apple.screensaver loginWindowIdleTime 0
