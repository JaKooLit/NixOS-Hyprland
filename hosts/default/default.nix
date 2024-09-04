# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, username, lib, inputs, system,... }:

  {
  # Kernel Parameters miniPC
  boot = {
    kernelParams = [ 
      "nowatchdog"
	   "modprobe.blacklist=iTCO_wdt"
 	  ];
  
    initrd = { 
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ ];
    };
  
    kernelModules = [ ];
    extraModulePackages = [ ];

    # bootloader grub theme
    loader.grub = rec {
      theme = inputs.distro-grub-themes.packages.${system}.nixos-grub-theme;
      splashImage = "${theme}/splash_image.jpg";
    };

    # Kernel 
    #kernelPackages = pkgs.linuxPackages_latest;
  };
  
  networking.hostName = "NixOS-MiniPC";
  
  # User account
  users = {
	  users."${username}" = {
    isNormalUser = true;
    extraGroups = [ 
		  "wheel" 
		  "video" 
		  "input" 
		  "audio"
		]; 
    packages = with pkgs; [		
     	];
  	};

	defaultUserShell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];

  # for HP - Mini pc
  environment.systemPackages = with pkgs; [
    discord
    fzf
    glxinfo
    krabby
    vscodium
    nvtopPackages.intel # requires unstable channel

	qbittorrent
  ];

  # Additional fonts needed for office stuff
  fonts.packages = with pkgs; [
	  cascadia-code
 	  ];
	
  powerManagement = {
	  enable = true;
	  cpuFreqGovernor = "performance";
  };
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;
    
  # HARDWARES:
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

	cpu.intel.updateMicrocode = true;

	graphics = {
    	enable = true;
    	enable32Bit = true;
		  extraPackages = with pkgs; [
   			libva
			libva-utils	
     		];
  	};

  }; 

  services = {
	  blueman.enable = true;
	  xserver.videoDrivers = ["intel"];
	  #flatpak.enable = true;
  };
  
  # For Electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
}
