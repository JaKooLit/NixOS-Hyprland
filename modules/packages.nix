{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
 
    # Override for cliphis  aiting for update to reach unstable bracnh
    #  10-16-24
    #  https://nixpk.gs/pr-tracker.html?pr=348887

    #    (cliphist.overrideAttrs (_old: {
    #     src = pkgs.fetchFromGitHub {
    #       owner = "sentriz";
    #       repo = "cliphist";
    #       rev = "c49dcd26168f704324d90d23b9381f39c30572bd";
    #       sha256 = "sha256-2mn55DeF8Yxq5jwQAjAcvZAwAg+pZ4BkEitP6S2N0HY=";
    #       };
    #        vendorHash = "sha256-M5n7/QWQ5POWE4hSCMa0+GOVhEDCOILYqkSYIGoy/l0=";
    #      }))

 ## From systemPackages.nix

 # System Packages


    #  override for AGS to keep it at v1
       (ags.overrideAttrs (oldAttrs: {
        inherit (oldAttrs) pname;
        version = "1.8.2";
      }))

    cava
    clang
    cpufrequtils
    duf
    eza
    fastfetch
    ffmpeg
    glib # for gsettings to work
    git
    gsettings-qt
    killall
    libappindicator
    libnotify
    (mpv.override { scripts = [ mpvScripts.mpris ]; }) # with tray
    openssl # required by Rainbow borders
    pciutils
    wget
    xdg-user-dirs
    xdg-utils
    #AGS version 2.x not backward compatible with v1 at this time
    #ags 
    btop
    cliphist
    eog
    feh
    file-roller
    grim
    gtk-engine-murrine # for gtk themes
    aquamarine
    hyprlang
    hyprshot
    hyprutils
    hyprcursor 
    hypridle 
    hyprpolkitagent
    hyprpaper
    imagemagick
    inxi
    jq
    kitty
    libsForQt5.qtstyleplugin-kvantum # kvantum
    libsForQt5.qt5ct
    networkmanagerapplet
    nwg-look # requires unstable channel
    pamixer
    pavucontrol
    playerctl
    polkit_gnome
    pyprland
    qt6ct
    qt6.qtwayland
    qt6Packages.qtstyleplugin-kvantum # kvantum
    rofi-wayland
    slurp
    swappy
    swaynotificationcenter
    swww
    unzip
    wallust
    wdisplays
    wl-clipboard
    wlogout
    yad
    yt-dlp


 ## common packages 

    alacritty
    appimage-run
    bat
    bottom
    gping
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    htop
    lsd
    ncdu
    neovim
    nh
    ripgrep
    tldr
    ugrep
  ];

  # FONTS
  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    noto-fonts-cjk-sans
    jetbrains-mono
    font-awesome
    terminus_font
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Added per VIMjoyner vidoe on setting up nixd
  nix.nixPath = ["nixpkgs = ${inputs.nixpkgs}"];
}
