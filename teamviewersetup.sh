# Set the username
username=$1

# Download the file from Google Drive
file_id="1saqhkHbhDcz4uF66asQVu6rYsYsvPCne"
destination="/Users/$username/Desktop/TeamViewer.app.zip"
sudo wget --no-check-certificate 'https://docs.google.com/uc?export=download&id='$file_id -O $destination

# Set the screensaver idle time to 0
sudo defaults write /Library/Preferences/com.apple.screensaver loginWindowIdleTime 0

# Unzip the downloaded file
sudo unzip /Users/$username/Desktop/TeamViewer.app.zip -d /Users/$username/Desktop/

# Remove the zip file
sudo rm /Users/$username/Desktop/TeamViewer.app.zip
