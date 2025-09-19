# Changelog 📓

A technical record of notable changes. Dates are in UTC.

## 19 Sep 2025

- Added
  - AGS re-added; quickshell updates were failing on some non-NixOS environments
    after recent upstream changes.
  - pyprland re-added by user request. It is present but not enabled by default.

- Changed
  - Consolidated common packages under modules/packages.nix; extracted fonts to
    modules/fonts.nix.
  - Removed duplicated packages and a stray programs-level xwayland flag
    (Hyprland’s own xwayland setting remains).
  - Installers refactored to use a shared library scripts/lib/install-common.sh
    with:
    - GPU profile detection (amd | intel | nvidia | nvidia-laptop | vm) with
      user confirmation.
    - pciutils check before use; robust host update in flake.nix.
    - Timezone prompt defaults to auto-detect
      (services.automatic-timezoned.enable = true) unless a manual TZ is set.
    - Console keymap prompt; keyboard layout still written to
      hosts/<host>/variables.nix.
    - fupdate/frebuild scripts fixed to target the active host via nh os switch
      -H ${host} .
  - Zsh defaults: enable programs.zsh at the system level; enable oh-my-zsh for
    the primary user; ensure ~/.zshrc sources /etc/zshrc.

- Fixed
  - Dark mode defaults are applied via system dconf (prefer-dark, Adwaita-dark,
    Papirus-Dark, Bibata cursor) with correct activation ordering.
  - Removed global GTK_THEME and QT_STYLE_OVERRIDE so nwg-look and apps can
    preview/apply themes dynamically; retained QT_QPA_PLATFORMTHEME=gtk3 and
    cursor variables.
  - Installers now toggle drivers/vm settings on the selected host rather than
    the default.

## 23 July 2025

- switched to unstable channel
- removed AGS from the option
- return to main Hyprland-Dots repo

## 17 July 2025

- Diverted KooLs Dots to download from specific branch until I figure out how to
  install quickshell on NixOS

## 20 March 2025

- added findutils as dependencies

## 10 March 2025

- Dropped pyprland in favor of hyprland built in tool for a drop down like
  terminal and Desktop magnifier

## 09 Mar 2025

- replaced eza with lsd

## 23 Feb 2025

- added Victor Mono Font for proper hyprlock font rendering for Dots v2.3.12
- added Fantasque Sans Mono Nerd for Kitty

## 22 Feb 2025

- replaced eog with loupe

## 15 Feb 2025

- Returning AGS overview option :)

## 13 Feb 2025

- disabled AGS permanently as it is trying to install version 2.2.1 even I set
  override
- switched to latest kernel (from zen kernel) to unstable channel (from 24.11)

## 30 Jan 2025

- AGS (aylurs gtk shell) v1 is now optional

## 27 Jan 2025

- switched to zen kernel for now until NixOS team fix the Kernel 6.13 plague

## 26 Jan 2025

- time will now be based via location
- switched to full stable branch

## 12 Jan 2025

- switch to final version of aylurs-gtk-shell-v1
- default oh-my-zsh theme was changed to `funky`

### 07 Jan 2025

- switched to non-development Hyprland

### 27 Dec 2024

- moved Packages and Fonts in a separate.nix. Thanks to @dwilliam62 for the lead

### 22 Oct 2024

- added brightnessctl
- updated packages names

### 18 Sep 2024

- removed neovim
- nvim config will be downloaded or copied into ~/.config anymore

### 08 Sep 2024

- officially released

### 07 Sep 2024

- Beta stage 🫰
- added zram

### 06 Sep 2024

- Alpha v2 Stage 😊

### 05 Sept 2024

- Initial Alpha Stage

