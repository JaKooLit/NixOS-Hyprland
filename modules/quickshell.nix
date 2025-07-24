{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.quickshell.packages.${pkgs.system}.default
    
    # Qt6 related kits（for slove Qt5Compat problem）
    qt6.qt5compat
    qt6.qtbase
    qt6.qtquick3d
    qt6.qtwayland
    qt6.qtdeclarative
    qt6.qtsvg
    
    # alternate options
        # libsForQt5.qt5compat
        kdePackages.qt5compat
        libsForQt5.qt5.qtgraphicaleffects
  ];
  
  # necessary environment variables
  environment.variables = {
    QML_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtbase}/lib/qt-6/qml";
    QML2_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtbase}/lib/qt-6/qml";
  };
  
  # make sure the Qt application is working properly
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };
}
