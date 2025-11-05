{ pkgs, lib, config, ... }:

{

  # Install themes/cursors that we reference
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    papirus-icon-theme
    bibata-cursors
    adwaita-qt
  ];

  # Environment variables as a fallback for apps not honoring gsettings
  # Avoid hard overrides so tools like nwg-look can preview/apply themes dynamically.
  environment.variables = {
    GTK2_RC_FILES = "${pkgs.gnome-themes-extra}/share/themes/Adwaita-dark/gtk-2.0/gtkrc"; # GTK2 fallback only
    QT_QPA_PLATFORMTHEME = "gtk3"; # Qt apps follow GTK portal/theme
  };

  # Cursor defaults for XDG/Wayland sessions
  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  # Set system dconf defaults so new users prefer dark by default.
  # Users can still override per-user via gsettings.
  environment.etc = {
    "dconf/profile/user".text = ''
      user-db:user
      system-db:local
    '';
    "dconf/db/local.d/00_theme".text = ''
      [org/gnome/desktop/interface]
      color-scheme='prefer-dark'
      gtk-theme='Adwaita-dark'
      icon-theme='Papirus-Dark'
      cursor-theme='Bibata-Modern-Classic'
    '';
  };

  # Rebuild the dconf database at activation to apply system defaults
  system.activationScripts.dconfUpdate = {
    # Ensure /etc is populated (including /etc/dconf/...) before running dconf update
    deps = [ "etc" ];
    text = ''
      if [ -x ${pkgs.dconf}/bin/dconf ]; then
        if [ -d /etc/dconf/db ]; then
          ${pkgs.dconf}/bin/dconf update || true
        fi
      fi
    '';
  };
}
