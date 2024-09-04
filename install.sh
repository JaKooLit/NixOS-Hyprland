#!/usr/bin/env bash

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
#git config --global user.name "installer"
#git config --global user.email "installer@gmail.com"
#git add .
sed -i "/^\s*host[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$hostName\"/" ./flake.nix


installusername=$(echo $USER)
sed -i "/^\s*username[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$installusername\"/" ./flake.nix

echo "-----"

echo "Generating The Hardware Configuration"
sudo nixos-generate-config --show-hardware-config > ./hosts/$hostName/hardware.nix

echo "-----"

echo "Setting Required Nix Settings Then Going To Install"
NIX_CONFIG="experimental-features = nix-command flakes"

echo "-----"

sudo nix flake update 
sudo nixos-rebuild switch --flake ~/NixOS-Hyprland/#${hostName}

sleep 1

printf "\n%.0s" {1..2}

# GTK Themes and Icons installation
printf "Installing GTK-Themes and Icons..\n"

if [ -d "GTK-themes-icons" ]; then
    echo "$NOTE GTK themes and Icons folder exist..deleting..." 
    rm -rf "GTK-themes-icons" 
fi

echo "$NOTE Cloning GTK themes and Icons repository..." 
if git clone https://github.com/JaKooLit/GTK-themes-icons.git ; then
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

sleep 1

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

# Check if hyprland is installed
if nix-env -q hyprland >/dev/null 2>&1; then
    printf "\n${OK} Yey! Installation Completed.\n"
    sleep 2
    printf "\n${NOTE} You can start Hyprland by typing Hyprland (IF SDDM is not installed) (note the capital H!).\n"
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
