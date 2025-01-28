{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  # nixfmt
  programs.nixfmt.enable = true;
  programs.nixfmt.package = pkgs.nixfmt-rfc-style;

  programs.prettier.enable = true;
  programs.shfmt.enable = true;
}
