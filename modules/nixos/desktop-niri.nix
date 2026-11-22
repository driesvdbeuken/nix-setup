{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.modules.nixos.desktop.niri;
in
{
  options.modules.nixos.desktop.niri = {
    enable = lib.mkEnableOption "Niri Wayland compositor and Noctalia shell";
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;

    services.upower.enable = true;  
    services.power-profiles-daemon.enable = true;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
      swaybg
      swaylock
      fuzzel
      nautilus
      brightnessctl
      playerctl
      wl-clipboard
    ];

    home-manager.users.dries = {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia = {
        enable = true;
      };

      home.packages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      gtk = {
        enable = true;
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      # Links both config.kdl and noctalia.kdl into ~/.config/niri/
      xdg.configFile."niri".source = ../../dotfiles/niri;
    };
  };
}