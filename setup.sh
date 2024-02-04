#Credit: https://github.com/Area69Lab
#setup.sh VNC_USER_PASSWORD VNC_PASSWORD NGROK_AUTH_TOKEN

# create your user
sudo dscl . -create /Users/$1
sudo dscl . -create /Users/$1 UserShell /bin/bash
sudo dscl . -create /Users/$1 RealName $2
sudo dscl . -create /Users/$1 UniqueID 1001
sudo dscl . -create /Users/$1 PrimaryGroupID 80
sudo dscl . -create /Users/$1 NFSHomeDirectory /Users/$1
sudo dscl . -passwd /Users/$1 $3
sudo dscl . -passwd /Users/$1 $3
sudo createhomedir -c -u $1 > /dev/null

# Enable the built-in VNC server 
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy no
echo $4 | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' |
sudo tee /Library/Preferences/com.apple.VNCSettings.txt
sudo -u root defaults write /Library/LaunchDaemons/com.startup.sysctl Label com.startup.sysctl
sudo -u root defaults write /Library/LaunchDaemons/com.startup.sysctl LaunchOnlyOnce -bool true
sudo -u root defaults write /Library/LaunchDaemons/com.startup.sysctl ProgramArguments -array /usr/sbin/sysctl net.inet.tcp.delayed_ack=0
sudo -u root defaults write /Library/LaunchDaemons/com.startup.sysctl RunAtLoad -bool true
sudo chmod 644 /Library/LaunchDaemons/com.startup.sysctl.plist
sudo chown root:wheel /Library/LaunchDaemons/com.startup.sysctl.plist
sudo launchctl load /Library/LaunchDaemons/com.startup.sysctl.plist

# Install ngrok using Homebrew
brew install ngrok

# Start ngrok tunnel
ngrok authtoken $5
ngrok tcp 5900 &

sudo chmod 777 /Users/$1/Desktop

# Set the username
username=$1

# Set the download URL for TeamViewer
url="https://download.teamviewer.com/download/TeamViewer.dmg"

# Set the destination path
dest="/Users/$username/Desktop"

# Download TeamViewer
echo "Downloading TeamViewer..."
curl -L $url -o $dest/TeamViewer.dmg

if [ $? -eq 0 ]; then
    echo "Download successful."
else
    echo "Download failed. Please check the URL or your internet connection."
    exit 1
fi

# Mount the dmg file
echo "Mounting the dmg file..."
mount_output=$(hdiutil attach $dest/TeamViewer.dmg)

if [ $? -eq 0 ]; then
    echo "Mounted the dmg file."
else
    echo "Failed to mount the dmg file. Please check the file path."
    exit 1
fi

# Get the mount point
mount_point=$(echo $mount_output | grep -o '/Volumes/.*' | awk '{print $1}')

# Move the TeamViewer app to the Desktop
echo "Installing TeamViewer..."
cp -R $mount_point/TeamViewer.app $dest/

# Unmount the dmg file
echo "Unmounting the dmg file..."
hdiutil detach $mount_point

echo "TeamViewer has been successfully installed on the Desktop."



