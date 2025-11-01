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

# Common installer functions
if [ -f "scripts/lib/install-common.sh" ]; then
    # shellcheck source=/dev/null
    . "scripts/lib/install-common.sh"
fi

if [ -n "$(grep -i nixos </etc/os-release)" ]; then
    echo "$OK Verified this is NixOS."
    echo "-----"
else
    echo "$ERROR This is not NixOS or the distribution information is not available."
    exit 1
fi

if command -v git &>/dev/null; then
    echo "$OK Git is installed, continuing with installation."
    echo "-----"
else
    echo "$ERROR Git is not installed. Please install Git and try again."
    echo "Example: nix-shell -p git"
    exit 1
fi

# Check for pciutils (lspci)
if ! command -v lspci >/dev/null 2>&1; then
    echo "$ERROR pciutils is not installed. Please install pciutils and try again."
    echo "Example: nix-shell -p pciutils"
    exit 1
fi

echo "-----"
printf "\n%.0s" {1..1}

echo "$NOTE Default options are in brackets []"
echo "$NOTE Just press enter to select the default"
sleep 1

echo "-----"

# Read from the controlling TTY to ensure interactivity even if stdin is redirected
read -rp "$CAT Enter Your New Hostname: [ default ] " hostName </dev/tty
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

# GPU/VM detection and toggles (operate on selected host)
if type nhl_detect_gpu_and_toggle >/dev/null 2>&1; then
    nhl_detect_gpu_and_toggle "$hostName"
fi
echo "-----"

read -rp "$CAT Enter your keyboard layout: [ us ] " keyboardLayout </dev/tty
if [ -z "$keyboardLayout" ]; then
    keyboardLayout="us"
fi

sed -i 's/keyboardLayout\s*=\s*"\([^"]*\)"/keyboardLayout = "'"$keyboardLayout"'"/' ./hosts/$hostName/variables.nix

# Timezone and console keymap
if type nhl_prompt_timezone_console >/dev/null 2>&1; then
    nhl_prompt_timezone_console "$hostName" "$keyboardLayout"
fi

echo "-----"

installusername=$(echo $USER)
sed -i 's/username\s*=\s*"\([^"]*\)"/username = "'"$installusername"'"/' ./flake.nix

echo "$NOTE Generating The Hardware Configuration"
attempts=0
max_attempts=3
hardware_file="./hosts/$hostName/hardware.nix"

while [ $attempts -lt $max_attempts ]; do
    sudo nixos-generate-config --show-hardware-config >"$hardware_file" 2>/dev/null

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
# Update host in flake.nix (first occurrence of host = "...")
sed -i -E '0,/(^\s*host\s*=\s*")([^"]*)(";)/s//\1'"$hostName"'\3/' ./flake.nix
# Verify
echo "$OK Hostname updated in flake.nix:"
grep -E "^[[:space:]]*host[[:space:]]*=" ./flake.nix | head -1 || true

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
if git clone --depth 1 https://github.com/JaKooLit/GTK-themes-icons.git; then
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
if command -v Hyprland &>/dev/null; then
    printf "\n${OK} Yey! Installation Completed.${RESET}\n"
    sleep 2
    printf "\n${NOTE} You must reboot your system to finish the installation.${RESET}\n\n"

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
