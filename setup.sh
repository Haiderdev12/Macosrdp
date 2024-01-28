#Credit: https://github.com/Area69Lab
#setup.sh VNC_USER_PASSWORD VNC_PASSWORD NGROK_AUTH_TOKEN

sudo dscl . -create /Users/lardex
sudo dscl . -create /Users/lardex UserShell /bin/bash
sudo dscl . -create /Users/lardex RealName "LardeX"
sudo dscl . -create /Users/lardex UniqueID 1001
sudo dscl . -create /Users/lardex PrimaryGroupID 80
sudo dscl . -create /Users/lardex NFSHomeDirectory /Users/lardex
sudo dscl . -passwd /Users/lardex $1
sudo dscl . -passwd /Users/lardex $1
sudo createhomedir -c -u lardex > /dev/null

# Download the RealVNC Connect setup app
curl -L -o realvnc.dmg https://www.realvnc.com/download/file/vnc.files/VNC-Server-6.8.1-MacOSX-x86_64.dmg

# Mount the disk image
sudo hdiutil attach realvnc.dmg

# Install the VNC Server and Viewer apps
sudo installer -pkg /Volumes/VNC\ Server/VNC\ Server.pkg -target /
sudo installer -pkg /Volumes/VNC\ Viewer/VNC\ Viewer.pkg -target /

# Unmount the disk image
hdiutil detach /Volumes/VNC\ Server
hdiutil detach /Volumes/VNC\ Viewer

# Delete the disk image
rm realvnc.dmg

# Set the VNC password for the user lardex
sudo -u lardex defaults write com.realvnc.vncserver VNCPassword $(printf "010206" | perl -w -e 'use MIME::Base64; print encode_base64(<STDIN>)')

# Start the VNC Server service
sudo launchctl load -w /Library/LaunchDaemons/com.realvnc.vncserver.plist

#install ngrok
brew install --cask ngrok

#configure ngrok and start it
ngrok authtoken $3
ngrok tcp 5900 &




