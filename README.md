<div align="center">

# 💌 ** KooL's ❄️ NixOS-Hyprland Install Script ** 💌

<p align="center">
  <img src="https://raw.githubusercontent.com/JaKooLit/Hyprland-Dots/main/assets/latte.png" width="400" />
</p>

![GitHub Repo stars](https://img.shields.io/github/stars/JaKooLit/NixOS-Hyprland?style=for-the-badge&color=cba6f7) ![GitHub last commit](https://img.shields.io/github/last-commit/JaKooLit/NixOS-Hyprland?style=for-the-badge&color=b4befe) ![GitHub repo size](https://img.shields.io/github/repo-size/JaKooLit/NixOS-Hyprland?style=for-the-badge&color=cba6f7) <a href="https://discord.gg/9JEgZsfhex"> <img src="https://img.shields.io/discord/1151869464405606400?style=for-the-badge&logo=discord&color=cba6f7&link=https%3A%2F%2Fdiscord.gg%9JEgZsfhex"> </a>


<br/>
</div>

<div align="center">
<br> 
  <a href="#-announcement-"><kbd> <br> Read this First <br> </kbd></a>&ensp;&ensp;
  <a href="#-1-using-auto-install-script"><kbd> <br> Auto Install <br> </kbd></a>&ensp;&ensp;
  <a href="#-2-manual"><kbd> <br> Manual Install <br> </kbd></a>&ensp;&ensp;
  <a href="#-reverting-back-to-your-default-configs"><kbd> <br> Reverting to your previous config <br> </kbd></a>&ensp;&ensp;
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
  <a href="https://discord.gg/9JEgZsfhex"><kbd> <br> Discord <br> </kbd></a>
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

https://github.com/JaKooLit/Hyprland-Dots/assets/85185940/50d53755-0f11-45d6-9913-76039e84a2cd

</div>

> [!CAUTION]
> This is not purely written in Nix-Language. You should check ZaneyOS. Link below


> [!NOTE]
> By default, all packages set to install are from NixOS unstable channel


#### 🪧🪧🪧 ANNOUNCEMENT 🪧🪧🪧
- This Repo does not contain Hyprland Dots or configs! Configs are NOT written in Nix. Hyprland Dotfiles will be downloaded from [`KooL's Hyprland-Dots`](https://github.com/JaKooLit/Hyprland-Dots). 

- The Hyprland-Dots used are constantly evolving / improving. you can check CHANGELOGS here [`Hyprland-Dots-Changelogs`](https://github.com/JaKooLit/Hyprland-Dots/wiki/Changelogs) 

- GTK Themes and Icons will be pulled from [`LINK`](https://github.com/JaKooLit/GTK-themes-icons), including Bibata Cursor Modern Ice

- The wallpapers offered to be downloaded towards the end are from this [`REPO`](https://github.com/JaKooLit/Wallpaper-Bank)

> [!IMPORTANT]
> Take note of the requirements

### 👋 👋 👋 Requirements 
- You must be running on NixOS.
- Minimum space required is 40gb. 60gb is recommended as NixOS is a space-hungry distro
- Must have installed NIXOS using GPT & UEFI. Systemd-boot is configured as the default bootloader, for GRUB users, you need to edit `hosts/default/config.nix` before installing
- Manually edit your host specific files. The host is the specific computer you're installing onto.


#### 🖥️ Multi Host & User Configuration
- You can now define separate settings for different host machines and users!
- Easily specify extra packages for your users in the users.nix file.
- Easy to understand file structure and simple, but encompassing, configuration.


#### 📦 How To Install Packages?
- You can search the [Nix Packages](https://search.nixos.org/packages?) & [Options](https://search.nixos.org/options?) pages for what a package may be named or if it has options available that take care of configuration hurdles you may face.
- Then edit `hosts/<your-hostname>/configs.nix` , `hosts/<your-hostname>/packages-fonts.nix` and/or `hosts/<your-hostname>/user.nix` depending on what you want. `config.nix` is for system packages with options. ie `pro  grams.hyprland.enable=true`, while packages-fonts.nix is for adding packages and changes made to user.nix are only available to the current user.
- Once you are finished editing, run `sudo nixos-rebuild switch --flake .#<your-hostname>` NOTE. omit < > and ensure you are in the directory where your **flake.nix** is. (For example: If you make the hostname `nixos` then your command should be `sudo nixos-rebuild switch --flake .#nixos`)

#### 🙋 Having Issues / Questions?
- Please feel free to raise an issue on the repo, please label a feature request with the title beginning with [feature request], thank you!
- If you have a question about KooL's Hyprland dots, see [`KooL's Dots WIKI`](https://github.com/JaKooLit/Hyprland-Dots/wiki). Contained within the wiki is an FAQ, along with other pages for tips, keybinds, and more!


### ⬇️ Installations
#### 📽 Youtube video for using this script
- [KooL's Hyprland Dots on NixOS](https://youtu.be/nJLnRgnLPWI)

#### 📜 1. Using auto install Script:
- This is the easiest and recommended way of starting out. 
- This script is NOT meant to allow you to change every option that you can in the flake or help you install extra packages. It is simply here so you can get my configuration installed with as little chance of breakages and then it is up to you to fiddle with to your heart's content!
- Simply copy this and run it:
```
nix-shell -p git vim curl pciutils
sh <(curl -L https://github.com/JaKooLit/NixOS-Hyprland/raw/main/auto-install.sh)
```
> [!NOTE]
> pciutils is necessary to detect if you have an Nvidia card. 



#### 🦽 2. Manual:
<details>
<summary align=center>Click here 👉🏻 Manual Installation</summary>

- Run this command to ensure git, curl, vim & pciutils are installed: Note: or nano if you prefer nano for editing
```
nix-shell -p git vim curl pciutils
```
- Clone this repo & CD into it:
```
git clone --depth 1 https://github.com/JaKooLit/NixOS-Hyprland.git ~/NixOS-Hyprland
cd ~/NixOS-Hyprland
```
- *You should stay in this folder for the rest of the install*
- Create the host folder for your machine(s)
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

</details>

#### 👉🏻 3. Alternative
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

> [!IMPORTANT]
> need to download in your home folder as some part of the installer are going back again to ~/NixOS-Hyprland

- *You should stay in this folder for the rest of the install*
- edit `hosts/default/config.nix` to your liking. Once you are satisfied, ran `./install.sh`



Now when you want to rebuild the configuration, you have access to an alias called `flake-rebuild` that will rebuild the flake!

Hope you enjoy! 🎉

#### 💔 known issues 💔 
- GTK themes, icons, and the cursor, are not applied automatically. gsettings does not seem to work.
- You can set GTK themes, icons, and the cursor, using nwg-look


#### 🪤 My NixOS configs 
- on this repo [`KooL's NIXOS Configs`](https://github.com/JaKooLit/NixOS-configs)


#### ⌨ Keybinds
- Keybinds [`CLICK`](https://github.com/JaKooLit/Hyprland-Dots/wiki/Keybinds)
> [!TIP]
> KooL's Dots v2.3.7 has a searchable keybind function via rofi. (SUPER SHIFT K) or right click the `HINTS` waybar button


#### 🫥 Improving performance for Older Nvidia Cards using driver 470
- [`SEE HERE`](https://github.com/JaKooLit/Hyprland-Dots/discussions/123#discussion-6035205)

### 🔙 Reverting back to your default configs
- If you use flakes, you can just simply locate your default or previous configs. CD into it and execute `sudo nixos-rebuild switch --flake .#<your-previous-flake-hostname>`
- If you didn't have flakes enabled previously, simply running `sudo nixos-rebuild switch` will revert you to your default configs contained in `/etc/nixos/` 
- ⚠️ just remember to clean up your nix/store to remove unnessary garbage from your system `sudo nix-collect-garbage -d`
- OR, simply just revert into a previous generation of your system by choosing which generation to boot via your bootloader.

#### 📒 Final Notes
- join my discord channel [`Discord`](https://discord.com/invite/9JEgZsfhex)
- Feel free to copy, re-distribute, and use this script however you want. Would appreciate if you give me some loves by crediting my work :)

#### ⏩ Contributing
- As stated above, this script does not contain actual config files. The only objective of this repository is to get my configuration working with as few issues as possible.
- If you want to contribute and/or test the Hyprland-Dotfiles (development branch), [`Hyprland-Dots-Development`](https://github.com/JaKooLit/Hyprland-Dots/tree/development) 


#### 👍👍👍 Thanks and Credits!
- [`Hyprland`](https://hyprland.org/) Of course to Hyprland and @vaxerski for this awesome Dynamic Tiling Manager.
- [`ZaneyOS`](https://gitlab.com/Zaney/zaneyos) - template including auto installation script and idea. ZaneyOS is a NixOS-Hyprland with home-manager. Written in pure nix language

## 💖 Support
- a Star on my Github repos would be nice 🌟

- Subscribe to my Youtube Channel [YouTube](https://www.youtube.com/@Ja.KooLit) 

- You can also buy me Coffee Through ko-fi.com or Coffee.com 🤩

<a href='https://ko-fi.com/jakoolit' target='_blank'><img height='35' style='border:0px;height:46px;' src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' />

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/JaKooLit)

####  📹 Youtube videos (Click to view and watch the playlist) 📹
[![Youtube Playlist Thumbnail](https://raw.githubusercontent.com/JaKooLit/screenshots/main/Youtube.png)](https://youtube.com/playlist?list=PLDtGd5Fw5_GjXCznR0BzCJJDIQSZJRbxx&si=iaNjLulFdsZ6AV-t)


## 🥰🥰 💖💖 👍👍👍
[![Stargazers over time](https://starchart.cc/JaKooLit/NixOS-Hyprland.svg?variant=adaptive)](https://starchart.cc/JaKooLit/NixOS-Hyprland)
