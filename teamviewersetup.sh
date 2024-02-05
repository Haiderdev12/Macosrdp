# Set the username
username=$1

# Download the TeamViewer Host
curl -L -o /tmp/TeamViewerHost.dmg "https://download.teamviewer.com/download/TeamViewerHost.dmg"

# Move the .dmg file to the user's Desktop
sudo mv /tmp/TeamViewerHost.dmg /Users/$username/Desktop/
