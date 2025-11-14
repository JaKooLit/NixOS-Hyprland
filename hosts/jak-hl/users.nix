# 💫 https://github.com/JaKooLit 💫 #
# Users - NOTE: Packages defined on this will be on current user only

{ pkgs, username, ... }:

let
  inherit (import ./variables.nix) gitUsername;
in
{
  users = { 
    mutableUsers = true;
    users."${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "video" 
        "input" 
        "audio"
      ];

    # define user packages here
    packages = with pkgs; [
      ];
    };
    
    defaultUserShell = pkgs.zsh;
  }; 
  
  environment.shells = with pkgs; [ zsh ];
  environment.systemPackages = with pkgs; [ lsd fzf git ]; 
   programs = {
    zsh = {
      ohMyZsh = {
        enable = true;
        theme = "agnoster";
        plugins = [ "git" ];
      };
      # Source plugins directly from the Nix store to avoid oh-my-zsh "not found" errors
      initExtra = ''
        # Enable autosuggestions
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

        # zsh-syntax-highlighting must be sourced at the end of .zshrc
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      '';
    };
  };
}
