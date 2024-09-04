{
  config, pkgs, host, username, host, options, inputs, ...}: let
  inherit (import ./variables.nix) keyboardLayout;
	in
  {
  imports = [
    ./hardware.nix
    ./users.nix
    ../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
  ];

  # BOOT related stuff
  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest; # Kernel

    kernelParams = [
    	"systemd.mask=systemd-vconsole-setup.service"
    	"systemd.mask=dev-tpmrm0.device" #this is to mask that stupid 1.5 mins systemd bug
      	"nowatchdog" 
	   	"modprobe.blacklist=sp5100_tco" #watchdog for AMD
      	"modprobe.blacklist=iTCO_wdt" #watchdog for Intel
 	  ];

    # This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # Needed For Some Steam Games
    #kernel.sysctl = {
    #  "vm.max_map_count" = 2147483642;
    #};
    
    # Bootloader SystemD
    loader.systemd-boot.enable = true;
	loader.efi = {
	  #efiSysMountPoint = "/efi"; #this is if you have separate /efi partition
	  canTouchEfiVariables = true;
	  timeout = 1;
  	  };
  			
  	# Bootloader GRUB
  	#loader.grub = {
	  enable = true;
	  devices = [ "nodev" ];
	  efiSupport = true;
  	  gfxmodeBios = "auto";
	  memtest86.enable = true;
	  extraGrubInstallArgs = [ "--bootloader-id=${host}" ];
	  configurationName = "${host}";
  		};

	
    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
    
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

  # Extra Module Options
  drivers.amdgpu.enable = true;
  drivers.nvidia.enable = false;
  drivers.nvidia-prime = {
    enable = false;
    intelBusID = "";
    nvidiaBusID = "";
  };
  drivers.intel.enable = false;
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = host;
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs = {
	  hyprland = {
      enable = true;
		  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; #hyprland-git
		  portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; # xdph
      xwayland.enable = true;
  	  };

	xwayland.enable = true;

	waybar.enable = true;
	hyprlock.enable = true;
	firefox.enable = true;
	git.enable = true;

	thunar.enable = true;
	thunar.plugins = with pkgs.xfce; [
		exo
		mousepad
		thunar-archive-plugin
		thunar-volman
		tumbler
  	];
	
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = false;
    
    #steam = {
    #  enable = true;
    #  gamescopeSession.enable = true;
    #  remotePlay.openFirewall = true;
    #  dedicatedServer.openFirewall = true;
    #};
	
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];    

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;
  };

  environment.systemPackages = with pkgs; [
  # System Packages
    baobab
    btrfs-progs
    cpufrequtils
	duf
    ffmpeg   
    glib #for gsettings to work
	killall  
    libappindicator
    libnotify
    openssl #required by Rainbow borders
    vim
    wget
    xdg-user-dirs
	xdg-utils
	
    fastfetch
    (mpv.override {scripts = [mpvScripts.mpris];}) # with tray
    ranger
      
    # Hyprland Stuff | Laptop related stuff on a separate .nix
	ags        
    btop
    cava
    cliphist
    eog
    gnome-system-monitor
    file-roller
    grim
    gtk-engine-murrine #for gtk themes
    hyprcursor # requires unstable channel
    hypridle # requires unstable channel
    inxi
    jq
    kitty
	libsForQt5.qtstyleplugin-kvantum #kvantum
	networkmanagerapplet
    nwg-look # requires unstable channel
    nvtopPackages.full
    pamixer
    pavucontrol
	playerctl
    polkit_gnome
    pyprland
    qt5ct
    qt6ct
    qt6.qtwayland
    qt6Packages.qtstyleplugin-kvantum #kvantum
    rofi-wayland
    slurp
    swappy
    swaynotificationcenter
    swww
    unzip
    wallust
    wl-clipboard
    wlogout
    yad

    #waybar  # if wanted experimental next line
    #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))
  ]) ++ [
	python-packages
  ];

  # FONTS
  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    noto-fonts-cjk
    jetbrains-mono
    font-awesome
	terminus_font
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
 	];

  # Services to start
  services = {
    xserver = {
      enable = false;
      xkb = {
        layout = "${keyboardLayout}";
        variant = "";
      };
    };
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          user = username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland"; # start Hyprland with a TUI login manager
        };
      };
    };
    smartd = {
      enable = false;
      autodetect = true;
    };
    envfs.enable = true;
    libinput.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    dbus.enable = true;
    openssh.enable = false;
    flatpak.enable = false;
    
    #printing = {
    #  enable = false;
    #  drivers = [
        # pkgs.hplipWithPlugin
    #  ];
    #};
    gnome.gnome-keyring.enable = true;
    #avahi = {
    #  enable = true;
    #  nssmdns4 = true;
    #  openFirewall = true;
    #};
    
    ipp-usb.enable = true;
    syncthing = {
      enable = false;
      user = "${username}";
      dataDir = "/home/${username}";
      configDir = "/home/${username}/.config/syncthing";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    rpcbind.enable = false;
    nfs.server.enable = false;
  };
  
  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  
  # Hardware stuff
  hardware = {
  	bluetooth = {
		enable = true;
		powerOnBoot = true;
		settings = {
			General = {
			Enable = "Source,Sink,Media,Socket";
			Experimental = true;
			};
		};
    };
    #sane = {
      #enable = true;
      #extraBackends = [ pkgs.sane-airscan ];
      #disabledDefaultBackends = [ "escl" ];
      #};

    # Extra Logitech Support
    logitech.wireless.enable = false;
    logitech.wireless.enableGraphical = false;

  
    pulseaudio.enable = false; # Enable sound with pipewire.
    
    # CPU Microcodes update
    cpu.amd.updateMicrocode = true;
    
	graphics = {
    	enable = true;
    	enable32Bit = true;
  	  };

    };  
  
  # Security / Polkit
  security = {
	pam.services.swaylock.text = "auth include login";
	polkit.enable = true;
	rtkit.enable = true;
  };
  
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';

  # zram
  zramSwap = {
	enable = true;
	priority = 100;
	memoryPercent = 30;
	swapDevices = 1;
    };
    
  # Cachix Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Virtualization / Containers
  #virtualisation.libvirtd.enable = true;
  #virtualisation.podman = {
  #  enable = true;
  #  dockerCompat = true;
  #  defaultNetwork.settings.dns_enabled = true;
  #};

  console.keyMap = "${keyboardLayout}";

  # SYSTEMD
  systemd.services = {
	  NetworkManager-wait-online.enable = false;
	  firewalld.enable = true;
	  power-profiles-daemon = {
		  enable = true;
		  wantedBy = [ "multi-user.target" ];
  		};
  };

  systemd.extraConfig = ''
  	DefaultTimeoutStartSec=5s
  	DefaultTimeoutStopSec=5s
  	''; 
  	
  # Masking sleep, hibernate, suspend
  systemd = {
	  targets = {
	    sleep = {
	    enable = false;
	    unitConfig.DefaultDependencies = "no";
  		};
	    suspend = {
	    enable = false;
	    unitConfig.DefaultDependencies = "no";
		  };
	    hibernate = {
	    enable = false;
	    unitConfig.DefaultDependencies = "no";
		  };
	    "hybrid-sleep" = {
	    enable = false;
	    unitConfig.DefaultDependencies = "no";
		  };
	  };
  };
  
  services = {  	
  	
  	blueman.enable = true;
  	
  	#hardware.openrgb.enable = true;
  	#hardware.openrgb.motherboard = "amd";
  };

  # For Electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}