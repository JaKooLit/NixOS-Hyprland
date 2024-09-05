
<div align="center">
<br> 
  <a href="#-announcement-"><kbd> <br> Read this First <br> </kbd></a>&ensp;&ensp;
  <a href="#installation"><kbd> <br> Installation <br> </kbd></a>&ensp;&ensp;
 </div><br>

<div align="center">

## 💌 ** JaKooLit's ❄️ NixOS-Hyprland Install Script ** 💌

![GitHub Repo stars](https://img.shields.io/github/stars/JaKooLit/NixOS-Hyprland?style=for-the-badge&color=cba6f7) ![GitHub last commit](https://img.shields.io/github/last-commit/JaKooLit/NixOS-Hyprland?style=for-the-badge&color=b4befe) ![GitHub repo size](https://img.shields.io/github/repo-size/JaKooLit/NixOS-Hyprland?style=for-the-badge&color=cba6f7) <a href="https://discord.gg/9JEgZsfhex"> <img src="https://img.shields.io/discord/1151869464405606400?style=for-the-badge&logo=discord&color=cba6f7&link=https%3A%2F%2Fdiscord.gg%9JEgZsfhex"> </a>


<br/>
</div>


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

<h3 align="center">
	<img src="https://github.com/JaKooLit/Telegram-Animated-Emojis/blob/main/Activity/Sparkles.webp" alt="Sparkles" width="38" height="38" />
	KooL Hyprland-Dotfiles Showcase 
	<img src="https://github.com/JaKooLit/Telegram-Animated-Emojis/blob/main/Activity/Sparkles.webp" alt="Sparkles" width="38" height="38" />
</h3>

<div align="center">

https://github.com/JaKooLit/Hyprland-Dots/assets/85185940/50d53755-0f11-45d6-9913-76039e84a2cd

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

#### 📜 Using auto install Script:
- This is the easiest and recommended way of starting out. The script is NOT meant to allow you to change every option that you can in the flake or help you install extra packages. It is simply here so you can get my configuration installed with as little chances of breakages and then fiddle to your hearts content!

- Simply copy this and run it:
```
nix-shell -p git curl
sh <(curl -L https://github.com/JaKooLit/NixOS-Hyprland/raw/main/auto-install.sh)
```

#### 🦽 Manual:
- Run this command to ensure Git & Vim are installed:
```
nix-shell -p git vim
```
- Clone this repo & CD into it:
```
git clone --depth 1 https://github.com/JaKooLit/NixOS-Hyprland.git
cd NixOS-Hyprland
```
- *You should stay in this folder for the rest of the install*
- Create the host folder for your machine(s)
```
cp -r hosts/default hosts/<your-desired-hostname>
```
- Edit as required the `config.nix` in `hosts/<your-desired-hostname>/`
- Generate your hardware.nix like so:
```
sudo nixos-generate-config --show-hardware-config > ./hosts/<your-desired-hostname>/hardware.nix
```
- Run this to enable flakes and install the flake replacing hostname with whatever you put as the hostname:
```
NIX_CONFIG="experimental-features = nix-command flakes" 
sudo nixos-rebuild switch --flake .#hostname
```
- Alternatively:
- auto install by running `./install.sh` after cloning and CD into NixOS-Hyprland
> [!NOTE]
> install.sh is a strip version of auto-install.sh as it will not re-download repo

Now when you want to rebuild the configuration you have access to an alias called flake-rebuild that will rebuild the flake!

Hope you enjoy! 🎉

#### 💔 known issues 💔 
- GTK themes and Icons including cursor not applied automatically. gsettings does not seem to work
- You can set the GTK Themes, icons and cursor using nwg-look


#### 🪤 My NixOS configs 
- on this repo [`KooL's NIXOS Configs`](https://github.com/JaKooLit/NixOS-configs)

#### 🫥 Improving performance for Older Nvidia Cards using driver 470
  - [`SEE HERE`](https://github.com/JaKooLit/Hyprland-Dots/discussions/123#discussion-6035205)

#### 📒 Final Notes
- join my discord channel [`Discord`](https://discord.com/invite/9JEgZsfhex)
- Feel free to copy, re-distribute, and use this script however you want. Would appreciate if you give me some loves by crediting my work :)

#### ⏩ Contributing
- As stated above, these script does not contain actual config files. These are only the installer of packages
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