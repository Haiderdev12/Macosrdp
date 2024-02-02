#Credit: https://github.com/Area69Lab
#setup.sh VNC_USER_PASSWORD VNC_PASSWORD NGROK_AUTH_TOKEN

# create serverrunner user
sudo dscl . -create /Users/serverrunner
sudo dscl . -create /Users/serverrunner UserShell /bin/bash
sudo dscl . -create /Users/serverrunner RealName "serverrunner"
sudo dscl . -create /Users/serverrunner UniqueID 1001
sudo dscl . -create /Users/serverrunner PrimaryGroupID 80
sudo dscl . -create /Users/serverrunner NFSHomeDirectory /Users/serverrunner
sudo dscl . -passwd /Users/serverrunner rdpserver
sudo dscl . -passwd /Users/serverrunner rdpserver
sudo createhomedir -c -u serverrunner > /dev/null

# create your user
sudo dscl . -create /Users/$1
sudo dscl . -create /Users/$1 UserShell /bin/bash
sudo dscl . -create /Users/$1 RealName $2
sudo dscl . -create /Users/$1 UniqueID 1002
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

# Authenticate your ngrok account with the token
ngrok authtoken $5

# Start ngrok and expose the Tomcat port (usually 8080)
ngrok tcp 5900 &

# Crea un collegamento internet sul desktop dell'utente lardex
sudo echo '[InternetShortcut]\nURL=https://www.gotomypc.com/members/login.tmpl?_ga=2.137430647.638229483.1706877186-1297556306.1706877186' > /Users/serverrunner/Desktop/link_safari.url

# Crea un file di testo con le credenziali fornite
sudo echo 'username: antoniolarducci16@gmail.com\npassword: fytzam-suHgi8-vonvoj' > /Users/lardex/Desktop/credentials.txt
