{
  pkgs,
  inputs,
  ...
}:
{

  programs = {
    hyprland = {
      enable = true;
      withUWSM = false;
      #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; #hyprland-git
      #portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; #xdph-git

      portalPackage = pkgs.xdg-desktop-portal-hyprland; # xdph none git
      xwayland.enable = true;
    };
    zsh.ohMyZsh.enable = true;
    firefox.enable = true;
    waybar.enable = true;
    hyprlock.enable = true;
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    git.enable = true;
    tmux.enable = true;
    nm-applet.indicator = true;
    neovim = {
      enable = true;
      defaultEditor = false;
    };
    xwayland.enable = true;

    thunar.enable = true;
    thunar.plugins = with pkgs.xfce; [
      exo
      mousepad
      thunar-archive-plugin
      thunar-volman
      tumbler
    ];

  };
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [

    # Update flkake script
    (pkgs.writeShellScriptBin "fupdate" ''
      cd ~/NixOS-Hyprland
       nh os switch -u -H {$hostname} flake.nix
    '')

    # Rebuild flkake script
    (pkgs.writeShellScriptBin "frebuild" ''
      cd ~/NixOS-Hyprland
       nh os switch -H {$hostname} flake.nix
    '')

    # clean up old generations
    (writeShellScriptBin "ncg" ''
      nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot
    '')

    # Hyprland Stuff
    hypridle
    hyprpolkitagent
    pyprland
    #uwsm
    hyprlang
    hyprshot
    hypridle
    hyprcursor
    mesa
    nwg-displays
    nwg-look
    waypaper
    hyprland-qt-support # for hyprland-qt-support

    #  Apps
    loupe
    appimage-run
    bc
    brightnessctl
    (btop.override {
      cudaSupport = true;
      rocmSupport = true;
    })
    bottom
    baobab
    btrfs-progs
    cmatrix
    dua
    duf
    cava
    cargo
    clang
    cmake
    cliphist
    cpufrequtils
    curl
    duf
    dysk
    eog
    eza
    findutils
    figlet
    ffmpeg
    ffmpeg
    fd
    feh
    file-roller
    glib # for gsettings to work
    gsettings-qt
    git
    google-chrome
    gnome-system-monitor
    fastfetch
    jq
    gcc
    git
    glib # for gsettings to work
    gnumake
    grim
    grimblast
    gsettings-qt
    gtk-engine-murrine # for gtk themes
    inxi
    imagemagick
    killall
    kdePackages.qt6ct
    kdePackages.qtwayland
    kdePackages.qtstyleplugin-kvantum # kvantum
    lazydocker
    libappindicator
    libnotify
    libsForQt5.qtstyleplugin-kvantum # kvantum
    libsForQt5.qt5ct
    (mpv.override { scripts = [ mpvScripts.mpris ]; }) # with tray
    nvtopPackages.full
    openssl # required by Rainbow borders
    pciutils
    (mpv.override { scripts = [ mpvScripts.mpris ]; }) # with tray
    networkmanagerapplet
    #nitrogen
    #nvtopPackages.full
    pamixer
    pavucontrol
    playerctl
    #polkit
    # polkit_gnome
    kdePackages.polkit-kde-agent-1
    # qt6ct
    #qt6.qtwayland
    #qt6Packages.qtstyleplugin-kvantum # kvantum
    # gsettings-qt
    rofi
    slurp
    swappy
    swaynotificationcenter
    swww
    unzip
    wallust
    wdisplays
    wl-clipboard
    wlr-randr
    wlogout
    wget
    xdg-user-dirs
    xdg-utils
    wlogout
    xarchiver
    xdg-user-dirs
    xdg-utils
    yad
    yazi
    yt-dlp

    (inputs.quickshell.packages.${pkgs.system}.default)
    (inputs.ghostty.packages.${pkgs.system}.default)
    (inputs.ags.packages.${pkgs.system}.default)

    # Utils
    caligula # burn ISOs at cli FAST
    atop
    gdu
    glances
    gping
    htop
    hyfetch
    ipfetch
    lolcat
    lsd
    oh-my-posh
    pfetch
    ncdu
    ncftp
    ripgrep
    socat
    starship
    tldr
    ugrep
    unrar
    v4l-utils
    obs-studio
    zoxide

    # Hardware related
    cpufetch
    cpuid
    cpu-x
    #gsmartcontrol
    smartmontools
    light
    lm_sensors
    mission-center
    neofetch
    pfetch

    # Development related
    luarocks
    nh

    # Internet
    discord

    # Virtuaizaiton
    virt-viewer
    libvirt

    # Video
    vlc

    # Terminals
    kitty
    wezterm

  ];

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      font-awesome
      hackgen-nf-font
      ibm-plex
      inter
      jetbrains-mono
      material-icons
      maple-mono.NF
      minecraftia
      nerd-fonts.im-writing
      nerd-fonts.blex-mono
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-monochrome-emoji
      powerline-fonts
      roboto
      roboto-mono
      symbola
      terminus_font
      victor-mono
    ];
  };

}
