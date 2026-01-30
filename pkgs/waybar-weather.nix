{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "waybar-weather";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "wneessen";
    repo = "waybar-weather";
    rev = "a8e4f8d45b16b00f14ff42cff13ad94db5f8c88a";
    hash = "sha256-I2g8TFsSN4y+QQ+cKVB2ea6TRgbhskIX7q3hCSnMpUs=";
  };

  vendorHash = "sha256-QdT0vKnCO+7DezbH8NUgPV18p6zmIMmLkK2XGWL8+3o=";

  subPackages = [ "cmd/waybar-weather" ];
  ldflags = [ "-s" "-w" ];

  postPatch = ''
    substituteInPlace go.mod --replace "go 1.25.6" "go 1.25.5"
  '';

  meta = with lib; {
    description = "Waybar module that displays weather information";
    homepage = "https://github.com/wneessen/waybar-weather";
    license = licenses.mit;
    mainProgram = "waybar-weather";
    platforms = platforms.linux;
  };
}
