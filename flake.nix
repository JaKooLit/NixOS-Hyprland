{
  description = "KooL's NixOS-Hyprland";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    #hyprland.url = "github:hyprwm/Hyprland"; # hyprland development
    #distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";

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
      host = "nixos-test";
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
            # Handle CUDA: disable if no NVIDIA, allow broken packages if NVIDIA enabled
            {
              nixpkgs.config.cudaSupport = config.drivers.nvidia.enable or config.drivers.nvidia-prime.enable or false;
              nixpkgs.config.allowBroken = config.drivers.nvidia.enable or config.drivers.nvidia-prime.enable or false;
            }
            ./modules/fonts.nix # Fonts packages
            ./modules/portals.nix # portal
            ./modules/theme.nix # Set dark theme
            ./modules/ly.nix # ly greater with matrix animation
            inputs.catppuccin.nixosModules.catppuccin
            # Integrate Home Manager as a NixOS module
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

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
