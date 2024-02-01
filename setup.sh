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

# Download the source code of guacamole-server 1.5.4
curl -L https://downloads.apache.org/guacamole/1.5.4/source/guacamole-server-1.5.4.tar.gz -o guacamole-server-1.5.4.tar.gz

# Extract the source code
tar xzf guacamole-server-1.5.4.tar.gz

# Install the dependencies using Homebrew
brew install cairo libjpeg-turbo libpng ossp-uuid
brew install libogg libvorbis libpulse pango
brew install libavcodec libavformat libavutil libssh2 libssl libswscale
brew install libtelnet libVNCServer libwebsockets libwebp wsock32

# Navigate to the source code directory
cd guacamole-server-1.5.4

# Configure and compile guacamole-server
./configure --with-init-dir=/Library/LaunchDaemons
make
sudo make install

# Start the guacd daemon
sudo launchctl load /Library/LaunchDaemons/org.apache.guacamole.guacd.plist

# Download the binary file of guacamole-client 1.5.4
curl -L https://downloads.apache.org/guacamole/1.5.4/binary/guacamole-1.5.4.war -o guacamole.war

# Install Apache Tomcat using Homebrew
brew install tomcat

# Copy the guacamole.war file to the webapps directory of Tomcat
sudo cp guacamole.war /usr/local/Cellar/tomcat/9.0.53/libexec/webapps/

# Restart Tomcat
sudo /usr/local/Cellar/tomcat/9.0.53/libexec/bin/shutdown.sh
sudo /usr/local/Cellar/tomcat/9.0.53/libexec/bin/startup.sh

# Create the .guacamole directory and the guacamole.properties file
mkdir ~/.guacamole
echo "guacd-hostname: localhost" > ~/.guacamole/guacamole.properties
echo "guacd-port: 4822" >> ~/.guacamole/guacamole.properties
echo "user-mapping: /Users/$USER/.guacamole/user-mapping.xml" >> ~/.guacamole/guacamole.properties

# Create the user-mapping.xml file with a connection named macOS
cat << EOF > ~/.guacamole/user-mapping.xml
<user-mapping>
    <authorize username="lardex" password=$2>
        <connection name="macOS">
            <protocol>vnc</protocol>
            <param name="hostname">localhost</param>
            <param name="port">5900</param>
            <param name="password">your-vnc-server-password</param>
        </connection>
    </authorize>
</user-mapping>
EOF 

# Enable the built-in VNC server 
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy no
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
ngrok authtoken $3

# Start ngrok and expose the Tomcat port (usually 8080)
ngrok http 8080

