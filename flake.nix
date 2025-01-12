# 💫 https://github.com/JaKooLit 💫 #

{
  description = "KooL's NixOS-Hyprland"; 
  	
  inputs = {
  	nixpkgs.url = "nixpkgs/nixos-unstable";
	#hyprland.url = "github:hyprwm/Hyprland"; # hyprland development
	distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
	ags.url = "github:aylur/ags/v1"; # aylurs-gtk-shell-v1
  	};

  outputs = 
	inputs@{ self, nixpkgs, ... }:
    	let
      system = "x86_64-linux";
      host = "NixOS-Hyprland";
      username = "alice";

    pkgs = import nixpkgs {
       	inherit system;
       	config = {
       	allowUnfree = true;
       	};
      };
    in
      {
	nixosConfigurations = {
      "${host}" = nixpkgs.lib.nixosSystem rec {
		specialArgs = { 
			inherit system;
			inherit inputs;
			inherit username;
			inherit host;
			};
	   		modules = [ 
				./hosts/${host}/config.nix 
				inputs.distro-grub-themes.nixosModules.${system}.default
				];
			};
		};
	};
}
