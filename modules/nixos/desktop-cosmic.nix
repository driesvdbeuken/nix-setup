{ config, lib, ... }:

let
  cfg = config.modules.nixos.desktop.cosmic;
in
{
  options.modules.nixos.desktop.cosmic = {
    enable = lib.mkEnableOption "System76 COSMIC desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services.desktopManager.cosmic.enable = true;
    services.system76-scheduler.enable = true;

    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
  };
}