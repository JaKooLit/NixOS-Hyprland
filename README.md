<div align="center">

## 💌 ** JaKooLit's ❄️ NixOS-Hyprland Install Script ** 💌

![GitHub Repo stars](https://img.shields.io/github/stars/JaKooLit/NixOS-Hyprland?style=for-the-badge&color=cba6f7) ![GitHub last commit](https://img.shields.io/github/last-commit/JaKooLit/NixOS-Hyprland?style=for-the-badge&color=b4befe) ![GitHub repo size](https://img.shields.io/github/repo-size/JaKooLit/NixOS-Hyprland?style=for-the-badge&color=cba6f7) <a href="https://discord.gg/9JEgZsfhex"> <img src="https://img.shields.io/discord/1151869464405606400?style=for-the-badge&logo=discord&color=cba6f7&link=https%3A%2F%2Fdiscord.gg%9JEgZsfhex"> </a>


<br/>
</div>

> [!NOTE]
> This is not purely written in Nix-Language. You should check ZaneyOS. Link below


> [!NOTE]
> hyprland to be installed will be from development branch or known as -git version

#### 🪧🪧🪧 ANNOUNCEMENT 🪧🪧🪧
- This Repo does not contain Hyprland Dots or configs! Nor Configs are NOT written in Nix. Hyprland Dotfiles will be downloaded from [`KooL's Hyprland-Dots`](https://github.com/JaKooLit/Hyprland-Dots) . 

- Hyprland-Dots use are constantly evolving / improving. you can check CHANGELOGS here [`Hyprland-Dots-Changelogs`](https://github.com/JaKooLit/Hyprland-Dots/wiki/Changelogs) 

- GTK Themes and Icons will be pulled from [`LINK`](https://github.com/JaKooLit/GTK-themes-icons) including Bibata Cursor Modern Ice

- the wallpaper offered to be downloaded towards the end are from this [`REPO`](https://github.com/JaKooLit/Wallpaper-Bank)

> [!IMPORTANT]
> take note of the requirements

### 👋 👋 👋 Requirements 
- You must be running on NixOS.
- Minimum space is 40gb. 60gb recommended as NixOS is a space hungry distro
- Must have installed using GPT & UEFI. Systemd-boot is what is supported, for GRUB you need to edit `hosts/default/config.nix`
- Manually editing your host specific files. The host is the specific computer your installing on.


#### 🖥️ Multi Host & User Configuration
- You can now define separate settings for different host machines and users!
- Easily specify extra packages for your users in the users.nix file.
- Easy to understand file structure and simple, but encompassing, configuratiion.


#### 📦 How To Install Packages?
- You can search the [Nix Packages](https://search.nixos.org/packages?) & [Options](https://search.nixos.org/options?) pages for what a package may be named or if it has options available that take care of configuration hurdles you may face.
- To add a package there are the sections for it in config.nix and users.nix in your host folder. One is for programs available system wide and the other for your users environment only.

#### 🙋 Having Issues / Questions?
- Please feel free to raise an issue on the repo, please label a feature request with the title beginning with [feature request], thank you!

### ⬇️ Installation

#### 📜 Script:

This is the easiest and recommended way of starting out. The script is NOT meant to allow you to change every option that you can in the flake or help you install extra packages. It is simply here so you can get my configuration installed with as little chances of breakages and then fiddle to your hearts content!

Simply copy this and run it:

```
nix-shell -p git curl
sh <(curl -L https://github.com/JaKooLit/NixOS-Hyprland/raw/main/auto-install.sh)

```


#### 🦽 Manual:

Run this command to ensure Git & Vim are installed:
```
nix-shell -p git vim
```

Clone this repo & CD into it:
```
git clone --depth 1 https://github.com/JaKooLit/NixOS-Hyprland.git
cd NixOS-Hyprland
```

- *You should stay in this folder for the rest of the install*

Create the host folder for your machine(s)
```
cp -r hosts/default hosts/<your-desired-hostname>
```

**🪧🪧🪧 Edit options.nix 🪧🪧🪧**

Generate your hardware.nix like so:
```
nixos-generate-config --show-hardware-config > hosts/<your-desired-hostname>/hardware.nix
```

Run this to enable flakes and install the flake replacing hostname with whatever you put as the hostname:
```
NIX_CONFIG="experimental-features = nix-command flakes" 
sudo nixos-rebuild switch --flake .#hostname
```

Alternatively:
auto install by running `./install.sh` after cloning and CD into NixOS-Hyprland
> [!NOTE]
> install.sh is a strip version of auto-install.sh as it will not re-download repo

Now when you want to rebuild the configuration you have access to an alias called flake-rebuild that will rebuild the flake!

Hope you enjoy!

#### 💔 known issues 💔 
- GTK themes and Icons including cursor not applied automatically. gsettings does not seem to work
- You can set the GTK Themes, icons and cursor using nwg-look


#### My NixOS configs 
- on this repo [`KooL's NIXOS Configs`](https://github.com/JaKooLit/NixOS-configs)

## 🫰 Credits
- [`ZaneyOS`](https://gitlab.com/Zaney/zaneyos) - template including auto installation script and idea. ZaneyOS is a NixOS-Hyprland with home-manager. Written in pure nix language