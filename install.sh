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
  exit 1
fi

if command -v git &> /dev/null; then
  echo "$OK Git is installed, continuing with installation."
  echo "-----"
else
  echo "$ERROR Git is not installed. Please install Git and try again."
  echo "Example: nix-shell -p git"
  exit 1
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

# configure for new hostname
mkdir hosts/"$hostName"

# Checking if running on a VM and enable in default config.nix
if hostnamectl | grep -q 'Chassis: vm'; then
  echo "${ORANGE}System is running in a virtual machine. Setting up guest${RESET}"
  sed -i '/vm\.guest-services\.enable = false;/s/vm\.guest-services\.enable = false;/ vm.guest-services.enable = true;/' hosts/default/config.nix
fi

# Checking if system has nvidia gpu and enable in default config.nix
if command -v lspci > /dev/null 2>&1; then
  # lspci is available, proceed with checking for Nvidia GPU
  if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
    echo "${YELLOW}Nvidia GPU detected. Setting up for nvidia${RESET}"
    sed -i '/drivers\.nvidia\.enable = false;/s/drivers\.nvidia\.enable = false;/ drivers.nvidia.enable = true;/' hosts/default/config.nix
  fi
fi

echo "-----"
printf "\n%.0s" {1..2}

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
sudo nixos-generate-config --show-hardware-config > hosts/$hostName/hardware.nix 2>/dev/null

echo "-----"

echo "Setting Required Nix Settings Then Going To Install"
NIX_CONFIG="experimental-features = nix-command flakes"

echo "-----"
printf "\n%.0s" {1..2}

sudo nixos-rebuild switch --flake .#${hostName}

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


# Cloning Hyprland-Dots repo to home folder
# KooL's Dots installation
printf "$NOTE Downloading Hyprland dots from main to HOME folder..\n"
if [ -d ~/Hyprland-Dots ]; then
  cd ~/Hyprland-Dots
  git stash
  git pull
  git stash apply
  chmod +x copy.sh
  ./copy.sh 
else
  if git clone --depth 1 https://github.com/JaKooLit/Hyprland-Dots ~/Hyprland-Dots; then
    cd ~/Hyprland-Dots || exit 1
    chmod +x copy.sh
    ./copy.sh 
  else
    echo -e "$ERROR Can't download Hyprland-Dots"
  fi
fi

cd ..

# copy fastfetch config for NixOS
cp -r assets/fastfetch ~/.config/ || true

printf "\n%.0s" {1..2}
if command -v Hyprland &> /dev/null; then
  printf "\n${OK} Yey! Installation Completed.${RESET}\n"
  sleep 2
  printf "\n${NOTE} You can start Hyprland by typing Hyprland (note the capital H!).${RESET}\n"
  printf "\n${NOTE} It is highly recommended to reboot your system.${RESET}\n\n"

  # Prompt user to reboot
  read -rp "${CAT} Would you like to reboot now? (y/n): ${RESET}" HYP

  if [[ "$HYP" =~ ^[Yy]$ ]]; then
    # If user confirms, reboot the system
    systemctl reboot
  else
    # Print a message if the user does not want to reboot
    echo "Reboot skipped."
  fi
else
  # Print error message if Hyprland is not installed
  printf "\n${WARN} Hyprland failed to install. Please check Install-Logs...${RESET}\n\n"
  exit 1
fi
