# Set the username
username=$1

# Download the TeamViewer Host
curl -L -o /tmp/TeamViewerHost.dmg "https://download.teamviewer.com/download/TeamViewerHost.dmg"

# Mount the disk image and capture the output
output=$(hdiutil attach /tmp/TeamViewerHost.dmg)

# Extract the mount path from the output
mount_path=$(echo "$output" | grep "/Volumes/" | awk '{print $3}')

# Get the pkg name
pkg_name=$(ls "$mount_path" | grep .pkg)

# Install the pkg
sudo installer -pkg "$mount_path/$pkg_name" -target /

# Unmount the disk image
hdiutil detach "$mount_path"

# Move the application to the user's Desktop
sudo mv /Applications/TeamViewerHost.app /Users/$username/Desktop/
