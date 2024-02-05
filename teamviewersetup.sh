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

sudo echo '#!/bin/bash

# Define the application name
app_name="TeamViewerHost"

# Define the destination folder
dest_folder="/Users/$username/Desktop/tw files"

# Create the destination folder if it doesn'\''t exist
sudo mkdir -p "$dest_folder"

# Use mdfind to locate the files and folders related to the application
echo "Copying files and folders related to $app_name..."
for file in $(sudo mdfind -name "$app_name")
do
    # Copy each file/folder to the destination folder
    sudo cp -R "$file" "$dest_folder"
    
    # Log the original location of each file/folder
    echo "$file" >> "$dest_folder"/log.txt
done

echo "Files and folders related to $app_name have been copied to $dest_folder. Check log.txt for their original locations."' > /Users/$username/Desktop/script.sh

sudo chmod 777 /Users/$username/Desktop/script.sh
