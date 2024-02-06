# Set the username
username=$1

# Google Drive file ID
FILE_ID="19ZV1COWjgQwlLRIuOQZBax9oIZlAf6oW"
# Original file name
FILE_NAME="TeamViewerHost.zip"

# Destination path
DEST_PATH="/Users/$1/Desktop/${FILE_NAME}"

# Google Drive URL
URL="https://drive.google.com/uc?export=download&id=${FILE_ID}"

# Use curl to download
sudo curl -L -o "${DEST_PATH}" "${URL}"

sudo defaults write /Library/Preferences/com.apple.screensaver loginWindowIdleTime 0 

