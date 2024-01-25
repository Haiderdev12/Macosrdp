# Reduce motion
sudo defaults write com.apple.universalaccess reduceMotion -bool true

# Set transparency off
sudo defaults write com.apple.universalaccess reduceTransparency -bool true

# Restart Dock and Finder to apply changes
sudo killall Dock
sudo killall Finder
