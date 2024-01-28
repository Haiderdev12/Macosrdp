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

#!/bin/bash

# Variables
SSH_PATH="$HOME/.ssh"
KEY_PATH="$SSH_PATH/id_ed25519"
EMAIL="erdripdebologna@gmail.com"

# Create .ssh directory if it doesn't exist
mkdir -p "$SSH_PATH"

# Save the private key to a file
echo $3 > "$KEY_PATH"

# Ensure the private key file has the correct permissions
chmod 600 "$KEY_PATH"

# Start the ssh-agent and add the private key
eval "$(ssh-agent -s)"
ssh-add "$KEY_PATH"

# Install Apache Guacamole
brew tap jaredledvina/guacamole
brew install guacamole-server

# Create a directory for Guacamole configuration
mkdir ~/.guacamole

# Create a guacamole.properties file
cat > ~/.guacamole/guacamole.properties <<EOF
# Hostname and port of guacamole proxy
guacd-hostname: localhost
guacd-port:     4822

# Auth provider class
auth-provider: net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider

# Properties used by BasicFileAuthenticationProvider
basic-user-mapping: ~/.guacamole/user-mapping.xml
EOF

# Create a user-mapping.xml file
cat > ~/.guacamole/user-mapping.xml <<EOF
<user-mapping>
    <!-- Per-user authentication and config information -->
    <authorize username="USERNAME" password="PASSWORD">
        <protocol>vnc</protocol>
        <param name="hostname">localhost</param>
        <param name="port">5900</param>
        <param name="password">VNC_PASSWORD</param>
    </authorize>
</user-mapping>
EOF

# Replace USERNAME, PASSWORD and VNC_PASSWORD with your own values
sed -i '' 's/lardex/your_username/g' ~/.guacamole/user-mapping.xml
sed -i '' 's/010206/your_password/g' ~/.guacamole/user-mapping.xml
sed -i '' 's/010206/your_vnc_password/g' ~/.guacamole/user-mapping.xml

# Install Tomcat
brew install tomcat

# Download Guacamole web application
curl -L -o guacamole.war https://downloads.apache.org/guacamole/1.5.4/binary/guacamole-1.5.4.war

# Deploy Guacamole web application to Tomcat
cp guacamole.war /usr/local/Cellar/tomcat/9.0.55/libexec/webapps/

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

# Start guacd service
brew services start guacamole-server

# Start Tomcat service
brew services start tomcat

echo "Access Guacamole web interface at http://localhost:8080/guacamole/"
# Log in with your username and password
# Enjoy your VNC connection to your Apple Remote Desktop


