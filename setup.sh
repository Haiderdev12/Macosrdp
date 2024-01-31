#Credit: https://github.com/Area69Lab
#setup.sh VNC_USER_PASSWORD VNC_PASSWORD NGROK_AUTH_TOKEN

#disable spotlight
sudo mdutil -i off -a

sudo dscl . -create /Users/lardex
sudo dscl . -create /Users/lardex UserShell /bin/bash
sudo dscl . -create /Users/lardex RealName "LardeX"
sudo dscl . -create /Users/lardex UniqueID 1001
sudo dscl . -create /Users/lardex PrimaryGroupID 80
sudo dscl . -create /Users/lardex NFSHomeDirectory /Users/lardex
sudo dscl . -passwd /Users/lardex $1
sudo dscl . -passwd /Users/lardex $1
sudo createhomedir -c -u lardex > /dev/null

#Enable VNC
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy no

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

# Clone noVNC repository
git clone https://github.com/novnc/noVNC.git

# Navigate into the noVNC directory
cd noVNC

# Install websockify
pip install websockify

#install ngrok
brew install --cask ngrok

# Start the noVNC server
./utils/novnc_proxy --vnc localhost:5900 &

#configure ngrok and start it
ngrok authtoken $3
ngrok http 6080 &

# Get the screen resolution
resolution=$(sudo system_profiler SPDisplaysDataType | grep Resolution)

# Parse the resolution to get the width and height
width=$(echo $resolution | cut -d ' ' -f 2)
height=$(echo $resolution | cut -d ' ' -f 4)

# Get the bandwidth
bandwidth=$(sudo networkQuality -v | grep "Download capacity" | cut -d ' ' -f 3)

# Convert bandwidth from Mbps to Kbps
bandwidth=$(echo "$bandwidth*1000" | bc)

# Set the compression and quality level based on bandwidth and resolution
if [[ $width -gt 1920 ]] || [[ $height -gt 1080 ]] || [[ $bandwidth -lt 100000 ]]; then
    # High resolution or low bandwidth - set lower compression and quality level
    sudo awk '{gsub(/compressionLevel = 6/, "compressionLevel = 2"); print}' vnc.html > temp && sudo mv temp vnc.html
    sudo awk '{gsub(/qualityLevel = 6/, "qualityLevel = 2"); print}' vnc.html > temp && sudo mv temp vnc.html
else
    # Low resolution or high bandwidth - set higher compression and quality level
    sudo awk '{gsub(/compressionLevel = 2/, "compressionLevel = 6"); print}' vnc.html > temp && sudo mv temp vnc.html
    sudo awk '{gsub(/qualityLevel = 2/, "qualityLevel = 6"); print}' vnc.html > temp && sudo mv temp vnc.html
fi










