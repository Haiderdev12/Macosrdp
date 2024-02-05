# Set the username
username=$1

# Download the TeamViewer Host
curl -L -o /tmp/TeamViewerHost.dmg "https://download.teamviewer.com/download/TeamViewerHost.dmg"

# Mount the disk image
hdiutil attach /tmp/TeamViewerHost.dmg

# Install the pkg
sudo installer -pkg /Volumes/TeamViewerHost/Install\ TeamViewerHost.pkg -target /

# Unmount the disk image
hdiutil detach /Volumes/TeamViewerHost

# Move the application to the user's Desktop
mv /Applications/TeamViewerHost.app /Users/$username/Desktop/
