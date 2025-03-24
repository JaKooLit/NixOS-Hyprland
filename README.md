<div align="center">

# 💌 ** KooL's ❄️ NixOS-Hyprland Install Script ** 💌

<p align="center">
  <img src="https://raw.githubusercontent.com/JaKooLit/Hyprland-Dots/main/assets/latte.png" width="400" />
</p>

![GitHub Repo stars](https://img.shields.io/github/stars/JaKooLit/NixOS-Hyprland?style=for-the-badge&color=cba6f7) ![GitHub last commit](https://img.shields.io/github/last-commit/JaKooLit/NixOS-Hyprland?style=for-the-badge&color=b4befe) ![GitHub repo size](https://img.shields.io/github/repo-size/JaKooLit/NixOS-Hyprland?style=for-the-badge&color=cba6f7) <a href="https://discord.gg/kool-tech-world"> <img src="https://img.shields.io/discord/1151869464405606400?style=for-the-badge&logo=discord&color=cba6f7&link=https%3A%2F%2Fdiscord.gg%kool-tech-world"> </a>


<br/>
</div>

<div align="center">
<br> 
  <a href="#announcement"><kbd> <br> Read this First <br> </kbd></a>&ensp;&ensp;
  <a href="#autoinstall"><kbd> <br> Auto Install <br> </kbd></a>&ensp;&ensp;
  <a href="#manualinstall"><kbd> <br> Manual Install <br> </kbd></a>&ensp;&ensp;
  <a href="#revertconfigs"><kbd> <br> Reverting to your previous config <br> </kbd></a>&ensp;&ensp;
 </div><br>

<p align="center">
  <img src="https://raw.githubusercontent.com/JaKooLit/Hyprland-Dots/main/assets/latte.png" width="200" />
</p>

<div align="center">
👇 KOOL's Hyprland-Dots related Links 👇
<br/>
</div>
<div align="center">
<br>
  <a href="https://github.com/JaKooLit/Hyprland-Dots"><kbd> <br> Hyprland-Dots repo <br> </kbd></a>&ensp;&ensp;
  <a href="https://www.youtube.com/playlist?list=PLDtGd5Fw5_GjXCznR0BzCJJDIQSZJRbxx"><kbd> <br> Youtube <br> </kbd></a>&ensp;&ensp;
  <a href="https://github.com/JaKooLit/Hyprland-Dots/wiki"><kbd> <br> Wiki <br> </kbd></a>&ensp;&ensp;
  <a href="https://github.com/JaKooLit/Hyprland-Dots/wiki/Keybinds"><kbd> <br> Keybinds <br> </kbd></a>&ensp;&ensp;
  <a href="https://github.com/JaKooLit/Hyprland-Dots/wiki/FAQ"><kbd> <br> FAQ <br> </kbd></a>&ensp;&ensp;
  <a href="https://discord.gg/kool-tech-world"><kbd> <br> Discord <br> </kbd></a>
</div><br>

<p align="center">
  <img src="https://raw.githubusercontent.com/JaKooLit/Hyprland-Dots/main/assets/latte.png" width="200" />
</p>

<h3 align="center">
	<img src="https://github.com/JaKooLit/Telegram-Animated-Emojis/blob/main/Activity/Sparkles.webp" alt="Sparkles" width="38" height="38" />
	KooL Hyprland-Dotfiles Showcase 
	<img src="https://github.com/JaKooLit/Telegram-Animated-Emojis/blob/main/Activity/Sparkles.webp" alt="Sparkles" width="38" height="38" />
</h3>

<div align="center">

https://github.com/user-attachments/assets/49bc12b2-abaf-45de-a21c-67aacd9bb872

</div>

> [!CAUTION]
> This is not purely written in Nix-Language. You should check ZaneyOS. Link below


> [!IMPORTANT]
> By default, all packages set to install are from NixOS stable channel. Note Hyprland to be installed will be of OLD version

- 25 Feb 2025 - I am really tired of baby sitting Unstable Channel. NixOS unstable d Most UNSTABLE Distro I have tried. If you are new to NixOS, stay on stable channel. However, if you wish to use unstable channel, you need to adjust `flake.nix` , `hosts/host/packages-fonts.nix`, `hosts/host/config.nix` before running the install.sh

- Make sure to read Hyprland's [WIKI](https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/)

<details>
<summary><strong> 🪧🪧🪧 Click for important announcements 🪧🪧🪧 </strong></summary>  
<br>    
<div id="announcement">

- ** This Repo does not contain Hyprland Dots or configs! **
- ** Configs are NOT written in NIX language **
- Hyprland Dotfiles will be downloaded from [`KooL's Hyprland-Dots`](https://github.com/JaKooLit/Hyprland-Dots)
- The Hyprland-Dots used are constantly evolving / improving
- You can check CHANGELOGS here [`Hyprland-Dots-Changelogs`](https://github.com/JaKooLit/Hyprland-Dots/wiki/Changelogs) 
- GTK Themes and Icons will be pulled from [`LINK`](https://github.com/JaKooLit/GTK-themes-icons), including Bibata Cursor Modern Ice
- The wallpapers offered to be downloaded towards the end are from this [`REPO`](https://github.com/JaKooLit/Wallpaper-Bank)

</div>
</details>
<br>
> [!IMPORTANT]
> Take note of the requirements
> 
<details>
<summary><strong>👋 👋 👋 Requirements </strong></summary>

- You must be running on NixOS 23.11+
- 24.11+ recommended 
- Minimum space required is 64gb. 128gb is recommended as NixOS is a space-hungry distro
- Must have installed NIXOS using **GPT partition ** & Boot **UEFI**
- `/boot` must be at least 512MB.
- Systemd-boot is configured as the default bootloader

> [!TIP]
> if you use GRUB as bootloader you need to edit `hosts/default/config.nix` before install and `flake.nix` for additional grub themes

</details>
<details>
<summary><strong> 🖥️ Multi Host & User Configuration </strong></summary>

- You can now define separate settings for different host machines and users!
- Easily specify extra packages for your users in the users.nix file.
- Easy to understand file structure and simple, but encompassing, configuration.
  
</details>
<details>
<summary><strong> 📦 How To Install Packages? </strong></summary>

- You can search the [Nix Packages](https://search.nixos.org/packages?)
- [Options](https://search.nixos.org/options?) pages for what a package may be named or if it has options available that take care of configuration hurdles you may face.
- By default, all the packages are in NixOS-Hyprland
- You can safely move directories `hosts` `modules` `flake.lock` & `flake.nix` in different single directory.
- If you have a set a different custom hostname, you can safely remove the default directory inside hosts.
- Then edit `hosts/<your-hostname>/configs.nix` , `hosts/<your-hostname>/packages-fonts.nix` and/or `hosts/<your-hostname>/user.nix` depending on what you want.
- The `config.nix` file is for system packages with options. ie `pro  grams.hyprland.enable=true`,
- The packages-fonts.nix file is for adding packages and changes made to user.nix are only available to the current user.
- Once you are finished editing, run `sudo nixos-rebuild switch --flake <path-where-you-move those directories above>/#"${hostName}"`

** NOTE. omit < > and ensure you are in the directory where your **flake.nix** is. 
    - For example: If you make the hostname `nixos` then your command should be `sudo nixos-rebuild switch --flake .#nixos`
- If you decided NOT to move the directories stated above, then you can rebuild with
 
```
sudo nixos-rebuild switch --flake ~/NixOS-Hyprland/#<hostName>
```
</details>

<details>
<summary><strong>🙋 Having Issues / Questions? </strong></summary>
    
- Please feel free to raise an issue on the repo, please label a feature request with the title beginning with [feature request], thank you!
- If you have a question about KooL's Hyprland dots, see [`KooL's Dots WIKI`](https://github.com/JaKooLit/Hyprland-Dots/wiki). Contained within the wiki is an FAQ, along with other pages for tips, keybinds, and more!
</details>


## ⬇️ Installation 
    
#### 📽 Youtube video for using this script
- [KooL's Hyprland Dots on NixOS](https://youtu.be/nJLnRgnLPWI)

<details>
<summary>📜 1. Using auto install Script: <</summary>
<br>
<div id="autoinstall">
    
- This is the easiest and recommended way of starting out. 
- This script is NOT meant to allow you to change every option that you can in the flake.
- It won't help you install extra packages.
- It is simply here so you can get my configuration installed with as little chance of breakages.
- It is up to you to fiddle with to your heart's content!
- Simply copy this and run it:
```
nix-shell -p git vim curl pciutils
sh <(curl -L https://github.com/JaKooLit/NixOS-Hyprland/raw/main/auto-install.sh)
```
> [!NOTE]
> pciutils is necessary to detect if you have an Nvidia card. 
</div?
</details>

<details>
<summary>🦽 2. Manual: </summary>
<br>
<div id="manualinstall">

- Run this command to ensure git, curl, vim & pciutils are installed: Note: or nano if you prefer nano for editing
```
nix-shell -p git vim curl pciutils
```
- Clone this repo & CD into it:
```
git clone --depth 1 https://github.com/JaKooLit/NixOS-Hyprland.git ~/NixOS-Hyprland
cd ~/NixOS-Hyprland
```
- *You should stay in this directory for the rest of the install*
- Create the host directory for your machine(s)
```
cp -r hosts/default hosts/<your-desired-hostname>
```
- Edit as required the `config.nix` , `packages-fonts.nix` and/or `users.nix` in `hosts/<your-desired-hostname>/`
- then generate your hardware.nix with:
```
sudo nixos-generate-config --show-hardware-config > hosts/<your-desired-hostname>/hardware.nix
```
- Run this to enable flakes and install the flake replacing hostname with whatever you put as the hostname:
```
NIX_CONFIG="experimental-features = nix-command flakes" 
sudo nixos-rebuild switch --flake .#hostname
```

Once done, you can install the GTK Themes and Hyprland-Dots. Links are above

</div>
</details>

<details>
<summary>👉🏻 3. Alternative </summary>
    
- auto install by running `./install.sh` after cloning and CD into NixOS-Hyprland
> [!NOTE]
> install.sh is a stripped version of auto-install.sh as it will not re-download repo

- Run this command to ensure git, curl, vim & pciutils are installed: Note: or nano if you prefer nano for editing
```
nix-shell -p git curl pciutils
```

- Clone this repo into your home directory & CD into it:
```
git clone --depth 1 https://github.com/JaKooLit/NixOS-Hyprland.git ~/NixOS-Hyprland
cd ~/NixOS-Hyprland
```
</details>


> [!IMPORTANT]
> need to download in your home directory as some part of the installer are going back again to ~/NixOS-Hyprland

- *You should stay in this directory for the rest of the install*
- edit `hosts/default/config.nix` to your liking. Once you are satisfied, ran `./install.sh`
Now when you want to rebuild the configuration, you have access to an alias called `flake-rebuild` that will rebuild the flake!

</details>

Hope you enjoy! 🎉

<details>
<summary><strong>💔 known issues 💔 </strong></summary>
- GTK themes, icons, and the cursor, are not applied automatically. gsettings does not seem to work.
- You can set GTK themes, icons, and the cursor, using nwg-look
</details>

🪤 My NixOS configs 
- on this repo [`KooL's NIXOS Configs`](https://github.com/JaKooLit/NixOS-configs)

🎞️ AGS Overview DEMO
- in case you wonder, here is a short demo of AGS overview [Youtube LINK](https://youtu.be/zY5SLNPBJTs)

⌨ Keybinds
- Keybinds [`CLICK`](https://github.com/JaKooLit/Hyprland-Dots/wiki/Keybinds)
> [!TIP]
> KooL's Dots v2.3.7 has a searchable keybind function via rofi. (SUPER SHIFT K) or right click the `HINTS` waybar button

<details>
<summary><strong>⌚ Setting timezone </strong></summary>
<br>    
    
- By default, your timezone is configured automatically using the internet. 
- To set your timezone manually, edit `host/<your-hostname>/config.nix`
 
</details>

#### 🫥 Improving performance for Older Nvidia Cards using driver 470
- [`SEE HERE`](https://github.com/JaKooLit/Hyprland-Dots/discussions/123#discussion-6035205)

<details>
<summary><strong>🔙 Reverting back to your default configs </strong></summary>
<br>
<div id="revertconfigs">
    
- If you use flakes, you can just simply locate your default or previous configs. CD into it and execute `sudo nixos-rebuild switch --flake .#<your-previous-flake-hostname>`
- If you didn't have flakes enabled previously, simply running `sudo nixos-rebuild switch` will revert you to your default configs contained in `/etc/nixos/` 
- ⚠️ just remember to clean up your nix/store to remove unnessary garbage from your system `sudo nix-collect-garbage -d`
- OR, simply just revert into a previous generation of your system by choosing which generation to boot via your bootloader.
</details>

#### 📒 Final Notes
- join my discord channel [`Discord`](https://discord.com/invite/kool-tech-world)
- Feel free to copy, re-distribute, and use this script however you want. Would appreciate if you give me some loves by crediting my work :)

<details>
<summary><strong>✍️ Contributing </strong></summary>
    
- As stated above, these script does not contain actual config files. These are only the installer of packages
- If you want to contribute and/or test the Hyprland-Dotfiles (development branch), [`Hyprland-Dots-Development`](https://github.com/JaKooLit/Hyprland-Dots/tree/development)
- Want to contribute on KooL-Hyprland-Dots Click [`HERE`](https://github.com/JaKooLit/Hyprland-Dots/blob/main/CONTRIBUTING.md) for a guide how to contribute
- Want to contribute on This Installer? Click [`HERE`](https://github.com/JaKooLit/NixOS-Hyprland/blob/main/CONTRIBUTING.md) for a guide how to contribute
</details>

👍👍👍 Thanks and Credits!
- [`Hyprland`](https://hyprland.org/) Of course to Hyprland and @vaxerski for this awesome Dynamic Tiling Manager.
- [`ZaneyOS`](https://gitlab.com/Zaney/zaneyos) - template including auto installation script and idea. ZaneyOS is a NixOS-Hyprland with home-manager. Written in pure nix language

</div>

<details>
<summary><strong>💖 Support </strong></summary>
    
- a Star on my Github repos would be nice 🌟

- Subscribe to my Youtube Channel [YouTube](https://www.youtube.com/@Ja.KooLit) 

- you can also give support through coffee's or btc 😊

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/jakoolit)

or

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/JaKooLit)

Or you can donate cryto on my btc wallet :)  
> 1N3MeV2dsX6gQB42HXU6MF2hAix1mqjo8i

![Bitcoin](https://github.com/user-attachments/assets/7ed32f8f-c499-46f0-a53c-3f6fbd343699)

</details>
<details>
<summary><strong> 📹 Youtube videos (Click to view and watch the playlist) 📹 </strong></summary>
[![Youtube Playlist Thumbnail](https://raw.githubusercontent.com/JaKooLit/screenshots/main/Youtube.png)](https://youtube.com/playlist?list=PLDtGd5Fw5_GjXCznR0BzCJJDIQSZJRbxx&si=iaNjLulFdsZ6AV-t)
</details>

🥰🥰 💖💖 👍👍👍
[![Stargazers over time](https://starchart.cc/JaKooLit/NixOS-Hyprland.svg?variant=adaptive)](https://starchart.cc/JaKooLit/NixOS-Hyprland)
