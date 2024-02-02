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

# Authenticate your ngrok account with the token
ngrok authtoken $5

# Start ngrok and expose the Tomcat port (usually 8080)
ngrok tcp 5900 &

sudo chmod 777 /Users/$1/Desktop

# Crea un collegamento internet sul desktop dell'utente serverrunner
echo 'https://www.gotomypc.com/members/login.tmpl?_ga=2.137430647.638229483.1706877186-1297556306.1706877186' > /Users/$1/Desktop/link_safari.txt

# Crea un file di testo con le credenziali fornite
echo 'username: antoniolarducci16@gmail.com\npassword: fytzam-suHgi8-vonvoj' > /Users/$1/Desktop/credentials.txt

# il tuo ngrok authtoken
echo $5 > /Users/$1/Desktop/authtoken.txt
