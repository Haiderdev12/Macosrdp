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

# Install XQuartz
echo "Installing XQuartz..."
brew install --cask xquartz

# Start XQuartz
echo "Starting XQuartz..."
open -a XQuartz

# Set DISPLAY environment variable
echo "Setting DISPLAY environment variable..."
export DISPLAY=:0

# Install FreeRDP
echo "Installing FreeRDP..."
brew install freerdp

# Define the rule
rule="pass in proto tcp from any to any port 3389"

# Write the rule to a file
sudo echo "$rule" > /tmp/com.apple.alf.plist

# Load the rule into the firewall
sudo pfctl -e -f /tmp/com.apple.alf.plist

# Start the FreeRDP server
echo "Starting the FreeRDP server..."
xfreerdp /server &

#install ngrok
brew install --cask ngrok

#configure ngrok and start it
ngrok authtoken $3
ngrok tcp 3389 &




