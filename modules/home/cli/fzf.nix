# Fzf is a general-purpose command-line fuzzy finder.
{lib, ...}: let
  # Static Catppuccin Mocha accents (no Stylix dependency)
  accent = "#89b4fa";
  foreground = "#cdd6f4";
  muted = "#6c7086";
in {
  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
    enableBashIntegration = false;
    enableFishIntegration = false;
    colors = lib.mkForce {
      "fg+" = accent;
      "bg+" = "-1";
      "fg" = foreground;
      "bg" = "-1";
      "prompt" = muted;
      "pointer" = accent;
    };
    # Basic options for all fzf usage (including history search)
    defaultOptions = [
      "--margin=1"
      "--layout=reverse"
      "--border=none"
      "--info='hidden'"
      "-i"
      "--no-bold"
    ];
    # File-specific options via environment variables
    fileWidgetOptions = [
      "--preview='bat --style=numbers --color=always --line-range :500 {}'"
      "--preview-window=right:60%:wrap"
    ];
    # History-specific options (keep it simple for Ctrl+R)
    historyWidgetOptions = [
      "--prompt='history> '"
    ];
  };
}
