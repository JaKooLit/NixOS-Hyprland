#!/usr/bin/env bash

set -e

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)


if [ -n "$(grep -i nixos < /etc/os-release)" ]; then
  echo "Verified this is NixOS."
  echo "-----"
else
  echo "$ERROR This is not NixOS or the distribution information is not available."
  exit
fi

if command -v git &> /dev/null; then
  echo "$OK Git is installed, continuing with installation."
  echo "-----"
else
  echo "$ERROR Git is not installed. Please install Git and try again."
  echo "Example: nix-shell -p git"
  exit
fi

echo "$NOTE Default options are in brackets []"
echo "$NOTE Just press enter to select the default"
sleep 2

echo "-----"

echo "Ensure In Home Directory"
cd || exit

echo "-----"

read -rp "$CAT Enter Your New Hostname: [ default ] " hostName
if [ -z "$hostName" ]; then
  hostName="default"
fi

echo "-----"

backupname=$(date "+%Y-%m-%d-%H-%M-%S")
if [ -d "NixOS-Hyprland" ]; then
  echo "NixOS-Hyprland exists, backing up to NixOS-Hyprland-backups folder."
  if [ -d "NixOS-Hyprland-backups" ]; then
    echo "Moving current version of NixOS-Hyprland to backups folder."
    mv "$HOME"/NixOS-Hyprland NixOS-Hyprland-backups/"$backupname"
    sleep 1
  else
    echo "Creating the backups folder & moving NixOS-Hyprland to it."
    mkdir -p NixOS-Hyprland-backups
    mv "$HOME"/NixOS-Hyprland NixOS-Hyprland-backups/"$backupname"
    sleep 1
  fi
else
  echo "$ORANGE Thank you for choosing KooL's NixOS-Hyprland"
  echo "$ORANGE I hope you find your time here enjoyable!"
fi

echo "-----"

echo "Cloning & Entering NixOS-Hyprland Repository"
git clone --depth 1 https://github.com/JaKooLit/NixOS-Hyprland.git
cd NixOS-Hyprland || exit
mkdir hosts/"$hostName"
cp hosts/default/*.nix hosts/"$hostName"
git config --global user.name "installer"
git config --global user.email "installer@gmail.com"
git add .
sed -i '/^\s*host[[:space:]]*=[[:space:]]*\"[^"]*\"/s/\"\([^"]*\)\"/\"'"$hostName"'\"/' ./flake.nix


read -rp "$CAT Enter your keyboard layout: [ us ] " keyboardLayout
if [ -z "$keyboardLayout" ]; then
  keyboardLayout="us"
fi

sed -i "/^\s*keyboardLayout[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$keyboardLayout\"/" ./hosts/$hostName/variables.nix

echo "-----"

installusername=$(echo $USER)
sed -i "/^\s*username[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$installusername\"/" ./flake.nix

echo "-----"

echo "Generating The Hardware Configuration"
sudo nixos-generate-config --show-hardware-config > ./hosts/$hostName/hardware.nix

echo "-----"

echo "Setting Required Nix Settings Then Going To Install"
NIX_CONFIG="experimental-features = nix-command flakes"

echo "-----"
printf "\n%.0s" {1..2}

sudo nixos-rebuild switch --flake ~/NixOS-Hyprland/#${hostName}

echo "-----"
printf "\n%.0s" {1..2}

# for initial zsh
# Check if ~/.zshrc and  exists, create a backup, and copy the new configuration
if [ -f "$HOME/.zshrc" ]; then
 	cp -b "$HOME/.zshrc" "$HOME/.zshrc-backup" || true
fi

# Copying the preconfigured zsh themes and profile
cp -r 'assets/.zshrc' ~/

# GTK Themes and Icons installation
printf "Installing GTK-Themes and Icons..\n"

if [ -d "GTK-themes-icons" ]; then
    echo "$NOTE GTK themes and Icons folder exist..deleting..." 
    rm -rf "GTK-themes-icons" 
fi

echo "$NOTE Cloning GTK themes and Icons repository..." 
if git clone --depth 1 https://github.com/JaKooLit/GTK-themes-icons.git ; then
    cd GTK-themes-icons
    chmod +x auto-extract.sh
    ./auto-extract.sh
    cd ..
    echo "$OK Extracted GTK Themes & Icons to ~/.icons & ~/.themes folders" 
else
    echo "$ERROR Download failed for GTK themes and Icons.." 
fi

echo "$OK Extracted Bibata-Modern-Ice.tar.xz to ~/.icons folder." 

echo "-----"
printf "\n%.0s" {1..2}

# KooL's Dots installation
printf "$NOTE Downloading Hyprland dots from main..\n"
if [ -d Hyprland-Dots ]; then
  cd Hyprland-Dots
  git stash
  git pull
  git stash apply
  chmod +x copy.sh
  ./copy.sh 
else
  if git clone --depth 1 https://github.com/JaKooLit/Hyprland-Dots; then
    cd Hyprland-Dots || exit 1
    chmod +x copy.sh
    ./copy.sh 
  else
    echo -e "$ERROR Can't download Hyprland-Dots"
  fi
fi

cd ..

echo "-----"
printf "\n%.0s" {1..3}

 # Check for existing configs and copy if does not exist
for DIR1 in gtk-3.0 Thunar xfce4; do
  DIRPATH=~/.config/$DIR1
  if [ -d "$DIRPATH" ]; then
    echo -e "${NOTE} Config for $DIR1 found, no need to copy." 
  else
    echo -e "${NOTE} Config for $DIR1 not found, copying from assets." 
    cp -r assets/$DIR1 ~/.config/ && echo "Copy $DIR1 completed!" || echo "Error: Failed to copy $DIR1 config files."
  fi
done

echo "-----"
printf "\n%.0s" {1..3}

# Clean up
# GTK Themes and Icons
if [ -d "GTK-themes-icons" ]; then
    echo "$NOTE GTK themes and Icons folder exist..deleting..." 
    rm -rf "GTK-themes-icons" 
fi

echo "-----"
printf "\n%.0s" {1..3}

printf "\n${OK} Yey! Installation Completed.\n"
sleep 2
printf "\n${NOTE} You can start Hyprland by typing Hyprland (note the capital H!).\n"
printf "\n${NOTE} It is highly recommended to reboot your system.\n\n"

# Prompt user to reboot
read -rp "${CAT} Would you like to reboot now? (y/n): " HYP

if [[ "$HYP" =~ ^[Yy]$ ]]; then
    # If user confirms, reboot the system
    sudo systemctl reboot
else
    # Print a message if the user does not want to reboot
    echo "Reboot skipped."
fi

