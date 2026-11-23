{ config, lib, pkgs, ... }:

let
  cfg = config.modules.nixos.desktop.gnome;
in
{
  options.modules.nixos.desktop.gnome = {
    enable = lib.mkEnableOption "GNOME desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = lib.mkDefault true;
    security.pam.services.gdm.enableGnomeKeyring = lib.mkDefault true;

    environment.systemPackages = with pkgs; [
      gnome-tweaks
    ];

    home-manager.users.dries = {
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };
  };
}