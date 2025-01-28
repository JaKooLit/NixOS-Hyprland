# 💫 https://github.com/JaKooLit 💫 #

{
  description = "KooL's NixOS-Hyprland"; 
  	
  inputs = {
	nixpkgs.url = "nixpkgs/nixos-24.11";
  	#nixpkgs.url = "nixpkgs/nixos-unstable";
	#hyprland.url = "github:hyprwm/Hyprland"; # hyprland development

	ags.url = "github:aylur/ags/v1"; # aylurs-gtk-shell-v1
	
	#distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes"; #for grub themes

    treefmt-nix.url = "github:numtide/treefmt-nix";
  	};

  outputs = 
	inputs@{ self, nixpkgs, systems, ... }:
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
    eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    treefmtEval = eachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
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
				#inputs.distro-grub-themes.nixosModules.${system}.default #for grub themes
				];
			};
		};
    formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
    checks = eachSystem (pkgs: {
    formatting = treefmtEval.${pkgs.system}.config.build.check self;
    });
	};
}
