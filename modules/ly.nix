{ config, lib, pkgs, ... }:
{
  # Ensure greetd is not enabled anywhere by default (hosts can override if needed)
  services.greetd.enable = lib.mkDefault false;

  # Enable ly globally with the Matrix animation
  # Animations  "doom", "colormix", "matrix"
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
    };
  };
}
