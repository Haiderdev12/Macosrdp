# Download the TeamViewer Host
curl -L -o /tmp/TeamViewerHost.dmg "https://download.teamviewer.com/download/TeamViewerHost.dmg"

# Move the .dmg file to the user's Desktop
sudo mv /tmp/TeamViewerHost.dmg /Users/$1/Desktop/

# Attach the dmg file
hdiutil attach /Users/$1/Desktop/TeamViewerHost.dmg -mountpoint /Volumes/TeamViewerHost

# Extract the application name
appname=$(ls /Volumes/TeamViewerHost | grep .app)

# Copy the application to the Desktop
cp -R /Volumes/TeamViewerHost/$appname /Users/$1/Desktop/

# Detach the dmg file
hdiutil detach /Volumes/TeamViewerHost

# Delete the dmg file
rm /Users/$1/Desktop/TeamViewerHost.dmg

sudo echo '#!/bin/bash

# Define the application name
app_name="TeamViewerHost"

# Define the destination folder
dest_folder="/Users/user/Desktop/tw files"

# Create the destination folder if it doesn'\''t exist
sudo mkdir -p "$dest_folder"

# Use mdfind to locate the files and folders related to the application
for file in $(sudo mdfind -name "$app_name")
do
    # Copy each file/folder to the destination folder
    sudo cp -R "$file" "$dest_folder"
    
    # Log the original location of each file/folder
    echo "$file" >> "$dest_folder"/log.txt
done

echo "Files and folders related to $app_name have been copied to $dest_folder. Check log.txt for their original locations."' > /Users/$1/Desktop/script.sh

sudo chmod 777 /Users/$1/Desktop/script.sh

