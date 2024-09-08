{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.local.hardware-clock;
in
{
  options.local.hardware-clock = {
    enable = mkEnableOption "Change Hardware Clock To Local Time";
  };

  config = mkIf cfg.enable { time.hardwareClockInLocalTime = true; };
}
