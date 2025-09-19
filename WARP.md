`
# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.
``

Project purpose
- This repo is a NixOS flake that provisions a Hyprland-based desktop with opinionated defaults and helper scripts. It is primarily an installer/host configuration, not a standalone app or library.
- It assumes being cloned to ~/NixOS-Hyprland in many places (install scripts and helper scripts cd to that path).

Quick commands
- Switch to a host configuration (apply immediately)
  - sudo nixos-rebuild switch --flake .#<host>
- Build without switching (verify it compiles)
  - sudo nixos-rebuild build --flake .#<host>
  - or: nix build .#nixosConfigurations.<host>.config.system.build.toplevel -L
- Evaluate/inspect flake
  - nix flake show
- Update inputs (updates flake.lock)
  - nix flake update
- Run the local installer (guided prompts; edits flake.nix and hosts/<host> and then rebuilds)
  - ./install.sh
- Helpers installed by the configuration (available after you’ve switched into this config)
  - frebuild: rebuild using nh os switch for the configured host (see modules/packages.nix)
  - fupdate: update then rebuild with nh os switch
  - ncg: collect garbage and switch boot configuration

Notes on tests and lint
- There is no test suite defined in this repository.
- No formatter/devShell is defined in flake.nix. Use your preferred Nix formatter locally if needed (e.g., nix fmt, alejandra, nixpkgs-fmt); none is wired into this flake.

High-level architecture
- Flake entrypoint: flake.nix
  - inputs: nixpkgs (nixos-unstable), quickshell.
  - outputs.nixosConfigurations.<host>: one host (default "default") is defined via nixpkgs.lib.nixosSystem.
  - specialArgs passed to modules: { system, inputs, username, host }.
  - Module stack included for each host:
    - ./hosts/${host}/config.nix (host base)
    - ./modules/quickshell.nix (QuickShell integration and Qt env)
    - ./modules/packages.nix (programs, Hyprland enablement, system packages, helper scripts)
    - ./modules/portals.nix (xdg-desktop-portal configuration)
    - ./modules/theme.nix (GTK/Qt theme env)

- Host directory: hosts/<host>/
  - config.nix
    - Imports:
      - ./hardware.nix (generated via nixos-generate-config --show-hardware-config)
      - ./users.nix (user account, shell, zsh/oh-my-zsh, lsd/fzf, aliases, promptInit)
      - ./packages-fonts.nix (extra packages and optional waybar override)
      - ../../modules/* driver/service toggles:
        - amd-drivers.nix, intel-drivers.nix, nvidia-drivers.nix, nvidia-prime-drivers.nix
        - vm-guest-services.nix, local-hardware-clock.nix
    - System composition highlights:
      - boot: zen kernel by default; systemd-boot enabled; EFI vars enabled; tmpfs config; appimage binfmt; plymouth enabled
      - drivers: custom options under drivers.* enable GPU stacks (amdgpu/intel/nvidia/nvidia-prime)
      - greetd: tuigreet launches Hyprland for the configured username
      - audio: pipewire+wireplumber; PulseAudio explicitly disabled on stable branch
      - portals: complemented by modules/portals.nix
      - bluetooth, flatpak, fwupd, upower, gvfs, tumbler enabled; openssh enabled
      - nix settings: flakes and nix-command enabled, Hyprland cachix configured, weekly GC
      - zramSwap enabled; power management tweaks
      - environment.sessionVariables: NIXOS_OZONE_WL=1 and QML_IMPORT_PATH for hyprland-qt-support
      - keyboard layout pulled from variables.nix
      - system.stateVersion set at host definition time
  - variables.nix: central simple settings
    - keyboardLayout, app defaults (browser terminal), git identity, minor UI toggles
  - users.nix: defines the primary user `${username}` via specialArgs
    - zsh with oh-my-zsh; aliases using lsd; fzf init in promptInit
  - packages-fonts.nix: additional packages
    - fastfetch; optional experimental waybar override commented

- Modules directory: modules/
  - packages.nix
    - Enables programs.hyprland with xwayland; selects portalPackage; turns on Firefox, Waybar, Hyprlock, Thunar, etc.
    - Populates environment.systemPackages with a broad set of desktop and utility tools.
    - Installs helper commands via writeShellScriptBin: fupdate, frebuild, ncg (they cd ~/NixOS-Hyprland and use nh or nix gc).
  - portals.nix
    - Configures xdg.portal with gtk and wlr portals; wlr.enable = true.
  - theme.nix
    - Sets GTK/Qt environment for a dark theme; installs Adwaita resources, Papirus icons, Bibata cursors; sets XCURSOR_*.
  - quickshell.nix
    - Adds QuickShell from inputs; sets QT/QML env to ensure Wayland and compatibility.
  - *-drivers.nix (amd/intel/nvidia/nvidia-prime)
    - Define options under drivers.* and, when enabled, configure video drivers and VAAPI/VDPAU stacks accordingly.
  - vm-guest-services.nix
    - Optional guest services (qemu-guest, spice-vdagentd/spice-webdavd) under vm.guest-services.enable.
  - local-hardware-clock.nix
    - Optional time.hardwareClockInLocalTime toggle under local.hardware-clock.enable.

Installer scripts
- auto-install.sh: remote bootstrap (intended for curl | sh usage); clones repository into ~/NixOS-Hyprland, prompts for host/keyboard layout, generates hardware.nix, amends flake.nix host/username, and rebuilds.
- install.sh: same flow for local clone; prompts and rebuilds. Both scripts may toggle drivers/vm based on detected environment via sed on hosts/default/config.nix.

Workflow for common tasks
- Add a new host
  1) cp -r hosts/default hosts/<your-host>
  2) Edit hosts/<your-host>/{config.nix,packages-fonts.nix,users.nix,variables.nix} as needed
  3) sudo nixos-generate-config --show-hardware-config > hosts/<your-host>/hardware.nix
  4) sudo nixos-rebuild switch --flake .#<your-host>
- Change default host used by flake
  - Edit flake.nix: set host = "<your-host>" and username appropriately.
- Switch GPU stack
  - In hosts/<host>/config.nix, set the desired drivers.* option to true (and fill in Bus IDs for nvidia-prime if used), then rebuild.

Important points from README
- This is an installer/configuration repo; it will not merge into an existing NixOS configuration automatically.
- Requirements: NixOS 23.11+ (24.11 recommended), UEFI with systemd-boot by default; adequate disk space.
- Hyprland dotfiles are not in this repo; they are pulled separately by the installer (Hyprland-Dots repo). GTK themes/icons can be pulled via installer as well.

Repository conventions
- No WARP/Claude/Cursor/Copilot rules are present in this repo.
- CONTRIBUTING.md, CODE_OF_CONDUCT.md, and COMMIT_MESSAGE_GUIDELINES.md exist; follow when contributing PRs.
