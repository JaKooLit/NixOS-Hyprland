{pkgs, ...}: {
  programs.nh = {
    enable = true;
    clean = {
      enable = false;
      extraArgs = "--keep-since 7d --keep 5";
    };
    flake = "/home/$USER/NixOS-Hyprland";
  };

  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nvd
  ];
}
