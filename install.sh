# 💫 https://github.com/JaKooLit 💫 #

#!/usr/bin/env bash

clear

printf "\n%.0s" {1..2}  
echo -e "\e[35m
	╦╔═┌─┐┌─┐╦    ╦ ╦┬ ┬┌─┐┬─┐┬  ┌─┐┌┐┌┌┬┐
	╠╩╗│ ││ │║    ╠═╣└┬┘├─┘├┬┘│  ├─┤│││ ││ 2025
	╩ ╩└─┘└─┘╩═╝  ╩ ╩ ┴ ┴  ┴└─┴─┘┴ ┴┘└┘─┴┘ 
\e[0m"
printf "\n%.0s" {1..1}

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
ORANGE="$(tput setaf 214)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

set -e 

if [ -n "$(grep -i nixos < /etc/os-release)" ]; then
  echo "$OK Verified this is NixOS."
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

# Checking if running on a VM and enable in default config.nix
if hostnamectl | grep -q 'Chassis: vm'; then
  echo "${NOTE} Your system is running on a VM. Enabling guest services.."
  echo "${WARN} A Kind reminder to enable 3D acceleration.."
  sed -i '/vm\.guest-services\.enable = false;/s/vm\.guest-services\.enable = false;/ vm.guest-services.enable = true;/' hosts/default/config.nix
fi

# Checking if system has nvidia gpu and enable in default config.nix
if command -v lspci > /dev/null 2>&1; then
  # lspci is available, proceed with checking for Nvidia GPU
  if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
    echo "${NOTE} Nvidia GPU detected. Setting up for nvidia..."
    sed -i '/drivers\.nvidia\.enable = false;/s/drivers\.nvidia\.enable = false;/ drivers.nvidia.enable = true;/' hosts/default/config.nix
  fi
fi

echo "-----"
printf "\n%.0s" {1..1}

# Aylurs GTK Shell v1 installation option
read -p "${CAT} Do you want to add ${MAGENTA}AGS or aylur's gtk shell v1${RESET} for Desktop Overview Like? (Y/n): " answer

answer=${answer:-Y}

if [[ "$answer" =~ ^[Nn]$ ]]; then
    sed -i 's|^\([[:space:]]*\)ags.url = "github:aylur/ags/v1";|\1#ags.url = "github:aylur/ags/v1";|' flake.nix
    sed -i 's|^\([[:space:]]*\)ags|\1#ags|' hosts/default/packages-fonts.nix
fi

echo "-----"
printf "\n%.0s" {1..1}

echo "$NOTE Default options are in brackets []"
echo "$NOTE Just press enter to select the default"
sleep 1

echo "-----"

read -rp "$CAT Enter Your New Hostname: [ default ] " hostName
if [ -z "$hostName" ]; then
  hostName="default"
fi

echo "-----"

# Create directory for the new hostname, unless the default is selected
if [ "$hostName" != "default" ]; then
  mkdir -p hosts/"$hostName"
  cp hosts/default/*.nix hosts/"$hostName"
  git add .
else
  echo "Default hostname selected, no extra hosts directory created."
fi
echo "-----"

read -rp "$CAT Enter your keyboard layout: [ us ] " keyboardLayout
if [ -z "$keyboardLayout" ]; then
  keyboardLayout="us"
fi

sed -i 's/keyboardLayout\s*=\s*"\([^"]*\)"/keyboardLayout = "'"$keyboardLayout"'"/' ./hosts/$hostName/variables.nix

echo "-----"

installusername=$(echo $USER)
sed -i 's/username\s*=\s*"\([^"]*\)"/username = "'"$installusername"'"/' ./flake.nix


echo "$NOTE Generating The Hardware Configuration"
attempts=0
max_attempts=3
hardware_file="./hosts/$hostName/hardware.nix"

while [ $attempts -lt $max_attempts ]; do
  sudo nixos-generate-config --show-hardware-config > "$hardware_file" 2>/dev/null

  if [ -f "$hardware_file" ]; then
    echo "${OK} Hardware configuration successfully generated."
    break
  else
    echo "${WARN} Failed to generate hardware configuration. Attempt $(($attempts + 1)) of $max_attempts."
    attempts=$(($attempts + 1))

    # Exit if this was the last attempt
    if [ $attempts -eq $max_attempts ]; then
      echo "${ERROR} Unable to generate hardware configuration after $max_attempts attempts."
      exit 1
    fi
  fi
done

echo "-----"

echo "$NOTE Setting Required Nix Settings Then Going To Install"
git config --global user.name "installer"
git config --global user.email "installer@gmail.com"
git add .
sed -i 's/host\s*=\s*"\([^"]*\)"/host = "'"$hostName"'"/' ./flake.nix

printf "\n%.0s" {1..2}

echo "$NOTE Rebuilding NixOS..... so pls be patient.."
echo "-----"
echo "$CAT In the meantime, go grab a coffee and stretch your legs or atleast do something!!..."
echo "-----"
echo "$ERROR YES!!! YOU read it right!!.. you staring too much at your monitor ha ha... joke :)......"
printf "\n%.0s" {1..2}
echo "-----"
printf "\n%.0s" {1..1}

# Set the Nix configuration for experimental features
NIX_CONFIG="experimental-features = nix-command flakes"
#sudo nix flake update
sudo nixos-rebuild switch --flake ~/NixOS-Hyprland/#"${hostName}"

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
    echo "$NOTE GTK themes and Icons directory exist..deleting..." 
    rm -rf "GTK-themes-icons" 
fi

echo "$NOTE Cloning GTK themes and Icons repository..." 
if git clone --depth 1 https://github.com/JaKooLit/GTK-themes-icons.git ; then
    cd GTK-themes-icons
    chmod +x auto-extract.sh
    ./auto-extract.sh
    cd ..
    echo "$OK Extracted GTK Themes & Icons to ~/.icons & ~/.themes directories" 
else
    echo "$ERROR Download failed for GTK themes and Icons.." 
fi

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
    echo "$NOTE GTK themes and Icons directory exist..deleting..." 
    rm -rf "GTK-themes-icons" 
fi

echo "-----"
printf "\n%.0s" {1..3}


# Cloning Hyprland-Dots repo to home directory
# KooL's Dots installation
printf "$NOTE Downloading Hyprland-Dots to HOME directory..\n"
if [ -d ~/Hyprland-Dots ]; then
  cd ~/Hyprland-Dots
  git stash
  git pull
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

#return to NixOS-Hyprland
cd ~/NixOS-Hyprland

# copy fastfetch config if nixos.png is not present
if [ ! -f "$HOME/.config/fastfetch/nixos.png" ]; then
    cp -r assets/fastfetch "$HOME/.config/"
fi


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