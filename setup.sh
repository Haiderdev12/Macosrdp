#Credit: https://github.com/Area69Lab
#setup.sh VNC_USER_PASSWORD VNC_PASSWORD NGROK_AUTH_TOKEN


# This script changes the password of runner to 010206, changes the username from runner to lardex, changes the real name from runner to lardex, and renames all the folders in the home folder from runner to lardex.

# Change the password of runner
echo "Changing the password of runner..."
# Use the resetpassword command in recovery mode to change the password without knowing the old one [^1^][1]
# Alternatively, use the dscl command with the -u and -P options to specify the admin user and password [^2^][2]
sudo dscl . -u admin -P adminpass -passwd /Users/runner 010206

# Change the username from runner to lardex
echo "Changing the username from runner to lardex..."
sudo dscl . -change /Users/runner RecordName runner lardex

# Change the real name from runner to lardex
echo "Changing the real name from runner to lardex..."
sudo dscl . -change /Users/lardex RealName runner lardex

# Rename the home folder from runner to lardex
echo "Renaming the home folder from runner to lardex..."
sudo mv /Users/runner /Users/lardex
sudo dscl . -change /Users/lardex NFSHomeDirectory /Users/runner /Users/lardex

# Rename all the folders in the home folder from runner to lardex
echo "Renaming all the folders in the home folder from runner to lardex..."
cd /Users/lardex
for dir in $(find . -type d -name "*runner*"); do
  newdir=$(echo $dir | sed 's/runner/lardex/g')
  sudo mv $dir $newdir
done

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
