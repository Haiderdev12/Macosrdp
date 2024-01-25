#Credit: https://github.com/Area69Lab
#setup.sh VNC_USER_PASSWORD VNC_PASSWORD NGROK_AUTH_TOKEN

#disable spotlight indexing
sudo mdutil -i off -a

#Create new account
sudo dscl . -create /Users/lardex
sudo dscl . -create /Users/lardex UserShell /bin/bash
sudo dscl . -create /Users/lardex RealName "LardeX"
sudo dscl . -create /Users/lardex UniqueID 1001
sudo dscl . -create /Users/lardex PrimaryGroupID 80
sudo dscl . -create /Users/lardex NFSHomeDirectory /Users/vncuser
sudo dscl . -passwd /Users/lardex $1
sudo dscl . -passwd /Users/lardex $1
sudo createhomedir -c -u lardex > /dev/null

#Enable VNC
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes 

#VNC password - http://hints.macworld.com/article.php?story=20071103011608872
echo $2 | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt
sudo -u root defaults write /Library/LaunchDaemons/com.startup.sysctl Label com.startup.sysctl
sudo -u root defaults write /Library/LaunchDaemons/com.startup.sysctl LaunchOnlyOnce -bool true
sudo -u root defaults write /Library/LaunchDaemons/com.startup.sysctl ProgramArguments -array /usr/sbin/sysctl net.inet.tcp.delayed_ack=0
sudo -u root defaults write /Library/LaunchDaemons/com.startup.sysctl RunAtLoad -bool true

# Set the permissions and ownership
sudo chmod 644 /Library/LaunchDaemons/com.startup.sysctl.plist
sudo chown root:wheel /Library/LaunchDaemons/com.startup.sysctl.plist

# Load the plist file
sudo launchctl load /Library/LaunchDaemons/com.startup.sysctl.plist

#Start VNC/reset changes
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate

# Get the display ID using defaults
sudo defaults read /Library/Preferences/com.apple.windowserver | grep -w "DisplayID" | cut -d " " -f 3 > display_id.txt

# Read the display ID from the file
sudo read display_id < display_id.txt

# Set the resolution using defaults
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionUserData -dict-add $display_id '<dict><key>Width</key><integer>1280</integer><key>Height</key><integer>720</integer></dict>'

# Delete the temporary file
sudo rm display_id.txt

# Restart the window server
sudo killall cfprefsd
sudo killall Dock

sudo echo "Resolution set to 1280x720 for display ID: $display_id"

#install ngrok
brew install --cask ngrok

#configure ngrok and start it
ngrok authtoken $3
ngrok tcp 5900 &

