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

# Download the NoMachine package for macOS
curl -O https://download.nomachine.com/download/8.11/MacOSX/nomachine_8.11.3_5.dmg

# Mount the disk image
hdiutil attach nomachine_8.11.3_5.dmg

# Install the package
sudo installer -pkg /Volumes/NoMachine/nomachine.pkg -target /

# Unmount the disk image
hdiutil detach /Volumes/NoMachine

address = ipconfig getifaddr en0

# Avvia il server di noMachine
sudo /Applications/NoMachine.app/Contents/Frameworks/bin/nxserver --start

#install ngrok
brew install --cask ngrok

#configure ngrok and start it
ngrok authtoken $3
ngrok tcp $address:4000 &




