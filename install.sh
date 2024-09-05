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

read -rp "$CAT Enter Your New Hostname: [ default ] " hostName
if [ -z "$hostName" ]; then
  hostName="default"
fi

echo "-----"

# creating host and adding to flake.nix
mkdir hosts/"$hostName"
cp hosts/default/*.nix hosts/"$hostName"

sed -i "/^\s*host[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$hostName\"/" ./flake.nix


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

sudo nixos-rebuild switch --flake .#${hostName}

echo "-----"
printf "\n%.0s" {1..2}

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

tar -xf "assets/Bibata-Modern-Ice.tar.xz" -C ~/.icons 
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

# Clean up
# GTK Themes and Icons
if [ -d "GTK-themes-icons" ]; then
    echo "$NOTE GTK themes and Icons folder exist..deleting..." 
    rm -rf "GTK-themes-icons" 
fi

printf "\n${OK} Yey! Installation Completed.\n"
sleep 2
printf "\n${NOTE} You can start Hyprland by typing Hyprland (note the capital H!).\n"
printf "\n${NOTE} It is highly recommended to reboot your system.\n\n"

    # Prompt user to reboot
read -rp "${CAT} Would you like to reboot now? (y/n): " HYP

    if [[ "$HYP" =~ ^[Yy]$ ]]; then
        sudo systemctl reboot
    fi
else
    # Print error message if neither package is installed
    printf "\n${WARN} Hyprland failed to install. Please check Install-Logs...\n\n"
    exit 1
fi
