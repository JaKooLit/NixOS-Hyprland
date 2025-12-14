{
  config,
  lib,
  ...
}: let
  overviewSource = ./overview;
in {
  # Quickshell-overview is a Qt6 QML app for Hyprland workspace overview
  # Toggled via: SUPER + TAB (added to Hyprland config separately)
  # Started via: exec-once = qs -c overview (added to Hyprland config separately)

  # Seed the Quickshell overview code into ~/.config/quickshell/overview
  # Copy (not symlink) so QML module resolution works and users can edit files
  home.activation.seedOverviewCode = lib.hm.dag.entryAfter ["writeBoundary"] ''
    set -eu
    DEST="$HOME/.config/quickshell/overview"
    SRC="${overviewSource}"

    mkdir -p "$HOME/.config/quickshell"
    # Remove old directory and copy fresh (ensures QML updates are picked up)
    rm -rf "$DEST"
    cp -R "$SRC" "$DEST"
    chmod -R u+rwX "$DEST"

    # Remove default shell.qml if it exists (prevents named config detection)
    # Quickshell disables subdirectory detection if ~/.config/quickshell/shell.qml exists
    if [ -f "$HOME/.config/quickshell/shell.qml" ]; then
      rm -f "$HOME/.config/quickshell/shell.qml"
    fi
  '';
}
