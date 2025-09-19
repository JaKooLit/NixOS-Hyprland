{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pkgs.adwaita-icon-theme  # Corrected for Adwaita theming and icons
    papirus-icon-theme  # Dark-friendly icon theme
    bibata-cursors  # Modern, dark-styled cursor theme
    adwaita-qt  # For Qt apps to match GTK dark styling
  ];

  environment.variables = {
    GTK_THEME = "Adwaita-dark";  # Set the GTK theme to dark (this will use available Adwaita resources)
    GTK2_RC_FILES = "${pkgs.gnome-themes-extra}/share/themes/Adwaita-dark/gtk-2.0/gtkrc";  # Fallback for GTK2 apps
    QT_STYLE_OVERRIDE = "adwaita-dark";  # Force Qt to use a dark style
    QT_QPA_PLATFORMTHEME = "gtk3";  # Make Qt apps follow GTK theme
  };

  programs.dconf.enable = true;  # Enables dconf for GTK app settings

  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";  # Adjust as needed
  };
}
