{
  pkgs,
  lib,
  ...
}: let
  settings = import ./yazi.nix;
  keymap = import ./keymap.nix;
  #theme = import ./theme.nix;
in {
  home.file.".config/yazi/theme.toml" = lib.mkForce {source = ./theme.toml;};

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    shellWrapperName = "yy";
    settings = settings;
    keymap = keymap;
    #theme = theme;
    plugins = {
      lazygit = pkgs.yaziPlugins.lazygit;
      full-border = pkgs.yaziPlugins.full-border;
      git = pkgs.yaziPlugins.git;
      smart-enter = pkgs.yaziPlugins.smart-enter;
    };

    initLua = ''
      require("full-border"):setup()
         require("git"):setup()
         require("smart-enter"):setup {
           open_multi = true,
         }
    '';
  };
}
