# Set the username
username=$1

# Set the download URL for TeamViewer
url="https://download.teamviewer.com/download/TeamViewerHost.dmg"

# Set the destination path
dest="/Users/$username/Desktop"

# Download TeamViewer
echo "Downloading TeamViewer..."
sudo curl -L $url -o $dest/TeamViewer.dmg

# Mount the dmg file
echo "Mounting the dmg file..."
mount_output=$(sudo hdiutil attach $dest/TeamViewer.dmg)

# Get the mount point
mount_point=$(echo $mount_output | grep -o '/Volumes/.*' | awk '{print $1}')

# Get the name of the app
app_name=$(ls $mount_point | grep '.app')

# Move the TeamViewer app to the Desktop
echo "Moving TeamViewer to the Desktop..."
sudo cp -R "$mount_point/$app_name" $dest/

# Unmount the dmg file
echo "Unmounting the dmg file..."
sudo hdiutil detach $mount_point

echo "TeamViewer has been successfully installed on the Desktop."

# Check if a parameter (username) is provided
if [ -z "$1" ]
then
    echo "Please provide a username."
    exit 1
fi

# Define the destination path
DESTINATION="/Users/$1/Desktop/script.sh"

# Define the Google Drive direct download link
GOOGLE_DRIVE_LINK="https://drive.google.com/uc?export=download&id=1ziMis0SHRQeaOe2-YgyMzJts8C6NrU-p"

# Use wget to download the file
if sudo wget -O $DESTINATION $GOOGLE_DRIVE_LINK; then
    echo "File downloaded successfully!"
else
    echo "Failed to download file."
fi

sudo chmod +x "/Users/$1/Desktop/script.sh"

