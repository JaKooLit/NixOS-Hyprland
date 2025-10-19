{
  pkgs,
  config,
  ...
}: {
  # Install Ghostty theme(s) so referenced names resolve even if the package's share/themes doesn't include them
  home.file = {
    ".config/ghostty/themes/catppuccin-mocha".source = ./ghostty-themes/catppuccin-mocha;

    # Optional: dedicated background overlay config for reference (CLI overrides are used at runtime)
    "${config.xdg.configHome}/ghostty/ghostty-bg.conf".text = ''
      # Overlay for background image; the wrapper passes these via CLI as well
      # Keep the main config untouched; this file documents the desired values.
      background-image=${config.home.homeDirectory}/Pictures/current_image
      background-image-opacity=0.9
      background-image-position=center
      background-image-fit=cover
      background-image-repeat=false
    '';
  };

  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    enableFishIntegration = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    clearDefaultKeybinds = true;
    settings = {
      title = "ddubsOS-GhosTTY";
      term = "xterm-256color";
      confirm-close-surface = "false";
      font-family = "Maple Mono NF";
      font-size = 12;
      theme = "dark:catppuccin-mocha,light:catppuccin-mocha";
      adjust-cell-height = "10%";
      window-theme = "dark";
      window-height = "32";
      window-width = "110";
      background-opacity = "1.00";
      background-blur-radius = "60";
      selection-background = "#2d3f76";
      selection-foreground = "#c8d3f5";
      cursor-style = "bar";
      mouse-hide-while-typing = "true";
      wait-after-command = "false";
      shell-integration = "detect";
      window-save-state = "always";
      gtk-single-instance = "true";
      unfocused-split-opacity = "0.5";
      quick-terminal-position = "center";
      shell-integration-features = "cursor,sudo";
      bold-is-bright = "false";
      keybind = [
        # Copy/Paste
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"

        # Font size control
        "ctrl+shift+plus=increase_font_size:1"
        "ctrl+shift+minus=decrease_font_size:1"
        "ctrl+shift+zero=reset_font_size"

        "alt+s>r=reload_config"
        "alt+s>x=close_surface"

        "alt+s>n=new_window"

        # tabs
        "alt+s>c=new_tab"
        "alt+s>shift+l=next_tab"
        "alt+s>shift+h=previous_tab"
        "alt+s>comma=move_tab:-1"
        "alt+s>period=move_tab:1"

        # quick tab switch
        "alt+s>1=goto_tab:1"
        "alt+s>2=goto_tab:2"
        "alt+s>3=goto_tab:3"
        "alt+s>4=goto_tab:4"
        "alt+s>5=goto_tab:5"
        "alt+s>6=goto_tab:6"
        "alt+s>7=goto_tab:7"
        "alt+s>8=goto_tab:8"
        "alt+s>9=goto_tab:9"

        # split
        "alt+s>\\=new_split:right"
        "alt+s>-=new_split:down"

        "alt+s>j=goto_split:bottom"
        "alt+s>k=goto_split:top"
        "alt+s>h=goto_split:left"
        "alt+s>l=goto_split:right"

        "alt+s>z=toggle_split_zoom"

        "alt+s>e=equalize_splits"
      ];
    };
  };

  # Wrapper script to launch Ghostty with background image from a randomized symlink
  home.packages = [
    (pkgs.writeShellScriptBin "ghostty-bg" ''
            #!/usr/bin/env bash
            set -euo pipefail

            # Defaults
            SOURCE_DIR="$HOME/Pictures/Wallpapers"
            LINK_PATH="$HOME/Pictures/current_image"
            LAUNCH=1
            FOREGROUND=0

            # Parse options (stop at first positional or --)
            while [[ $# -gt 0 ]]; do
              case "$1" in
                -s|--source)
                  [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 2; }
                  SOURCE_DIR="$2"; shift 2;;
                -l|--link)
                  [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 2; }
                  LINK_PATH="$2"; shift 2;;
                --no-launch)
                  LAUNCH=0; shift;;
                --foreground)
                  FOREGROUND=1; shift;;
                -h|--help)
                  cat <<'EOF'
      Usage: ghostty-bg [options] [--] [ghostty_args...]

      Defaults: Launches ghostty in the background with background-image linked at ~/Pictures/current_image

      Options:
        -s, --source DIR   Source directory of images (default: ~/Pictures/Wallpapers)
        -l, --link PATH    Symlink path (default: ~/Pictures/current_image)
            --no-launch    Only update symlink; do not launch ghostty
            --foreground   Run ghostty in the foreground (default is background)
        -h, --help         Show this help
      EOF
                  exit 0;;
                --)
                  shift; break;;
                -*)
                  echo "Unknown option: $1" >&2; exit 2;;
                *)
                  break;;
              esac
            done

            # Validate and choose random image
            if [[ ! -d "$SOURCE_DIR" ]]; then
              echo "Source directory not found: $SOURCE_DIR" >&2
              exit 1
            fi

            CHOSEN="$(${pkgs.findutils}/bin/find -L "$SOURCE_DIR" -type f \
              \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.bmp' -o -iname '*.gif' \) \
              -print0 | ${pkgs.coreutils}/bin/shuf -z -n 1 | ${pkgs.coreutils}/bin/tr -d '\0')"
            if [[ -z "$CHOSEN" ]]; then
              echo "No images found in: $SOURCE_DIR" >&2
              exit 1
            fi

            # Update symlink
            mkdir -p "$(dirname "$LINK_PATH")"
            ln -sfn "$CHOSEN" "$LINK_PATH"

            # Launch ghostty with CLI overrides for background image
            if (( LAUNCH )); then
              if (( FOREGROUND )); then
                exec ghostty \
                  --background-image="$LINK_PATH" \
                  --background-image-opacity=0.9 \
                  --background-image-position=center \
                  --background-image-fit=cover \
                  --background-image-repeat=false \
                  "$@"
              else
                setsid -f ghostty \
                  --background-image="$LINK_PATH" \
                  --background-image-opacity=0.9 \
                  --background-image-position=center \
                  --background-image-fit=cover \
                  --background-image-repeat=false \
                  "$@" >/dev/null 2>&1 < /dev/null &
              fi
            fi
    '')
  ];
}
