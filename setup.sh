#Credit: https://github.com/Area69Lab
#setup.sh VNC_USER_PASSWORD VNC_PASSWORD NGROK_AUTH_TOKEN


# Set up automatic login for runner
echo "Setting up automatic login for runner..."
# Use the defaults command to write the loginwindow preferences 
sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser runner
sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUserUID $(id -u runner)
sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUserScreenLocked 0

# Change the username from runner to lardex
echo "Changing the username from runner to lardex..."
# Use the -change option of dscl to modify the RecordName attribute 
sudo dscl . -change /Users/runner RecordName runner lardex

# Change the real name from runner to lardex
echo "Changing the real name from runner to lardex..."
# Use the -change option of dscl to modify the RealName attribute 
sudo dscl . -change /Users/lardex RealName runner lardex

# Rename the home folder from runner to lardex
echo "Renaming the home folder from runner to lardex..."
# Use the mv command to move the home folder to a new location
sudo mv /Users/runner /Users/lardex
# Use the -change option of dscl to modify the NFSHomeDirectory attribute 
sudo dscl . -change /Users/lardex NFSHomeDirectory /Users/runner /Users/lardex

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

#install ngrok
brew install --cask ngrok

#configure ngrok and start it
ngrok authtoken $3
ngrok tcp 5900 &
