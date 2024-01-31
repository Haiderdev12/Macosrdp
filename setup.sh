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

# Scarica il file dmg di NoMachine
curl -O https://download.nomachine.com/download/8.11/MacOSX/nomachine_8.11.3_5.dmg

# Estrai il file pkg dal file dmg
sudo pkgutil --expand nomachine_8.11.3_5.dmg nomachine

# Sposta il file pkg nella cartella corrente
sudo mv nomachine/nomachine.pkg .

# Rimuovi la cartella nomachine
sudo rm -rf nomachine

# Installa il file pkg
sudo installer -pkg nomachine.pkg -target / -verboseR

# Rimuovi il file pkg
sudo rm nomachine.pkg

# Avvia il servizio nxserver
sudo /Applications/NoMachine.app/Contents/Frameworks/bin/nxserver --start

# Crea un account utente per nxserver
sudo /Applications/NoMachine.app/Contents/Frameworks/bin/nxserver --useradd lardex --system --password 010206

# Abilita l'account utente per nxserver
sudo /Applications/NoMachine.app/Contents/Frameworks/bin/nxserver --userenable lardex

#install ngrok
brew install --cask ngrok

#configure ngrok and start it
ngrok authtoken $3
ngrok tcp 4001 &




