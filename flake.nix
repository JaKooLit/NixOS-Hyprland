{
  description = "KooL's NixOS-Hyprland";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-25.11";
    #hyprland.url = "github:hyprwm/Hyprland"; # hyprland development

    ags = {
      type = "github";
      owner = "aylur";
      repo = "ags";
      ref = "v1";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };


  outputs =
    inputs@{ self
    , nixpkgs
    , ags
    , ...
    }:
    let
      system = "x86_64-linux";
      host = "jak-hl";
      username = "dwilliams";

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
            # inputs.distro-grub-themes.nixosModules.${system}.default
            ./modules/overlays.nix # nixpkgs overlays (CMake policy fixes)
            ./modules/quickshell.nix # quickshell module
            ./modules/packages.nix # Software packages
            # Allow broken packages (temporary fix for broken CUDA in nixos-unstable)
            { nixpkgs.config.allowBroken = true; }
            ./modules/fonts.nix # Fonts packages
            ./modules/portals.nix # portal
            ./modules/theme.nix # Set dark theme
            ./modules/ly.nix # ly greater with matrix animation
            ./modules/nh.nix # nix helper 
            inputs.catppuccin.nixosModules.catppuccin
            # Integrate Home Manager as a NixOS module
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm-bak";

              # Ensure HM modules can access flake inputs (e.g., inputs.nixvim)
              home-manager.extraSpecialArgs = { inherit inputs system username host; };

              home-manager.users.${username} = {
                home.username = username;
                home.homeDirectory = "/home/${username}";
                home.stateVersion = "24.05";

                # Import your copied HM modules
                imports = [
                  ./modules/home/default.nix
                ];
              };
            }
          ];
        };
      };
    };
}
