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

# Install FreeRDP
echo "Installing FreeRDP..."
brew install freerdp

# Start the FreeRDP server
echo "Starting the FreeRDP server..."
xfreerdp /server &

#install ngrok
brew install --cask ngrok

#configure ngrok and start it
ngrok authtoken $3
ngrok tcp 3389 &




