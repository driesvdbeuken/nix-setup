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

    # Prevents NixOS from shadowing user PATH when niri-session starts
    systemd.user.services.niri.enableDefaultPath = false;

    # Use greetd + tuigreet for Niri
    services.displayManager.gdm.enable = false;
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --sessions /run/current-system/sw/share/wayland-sessions:/run/current-system/sw/share/xsessions --cmd niri-session";
          user = "greeter";
        };
      };
    };
    security.pam.services.greetd.enableGnomeKeyring = true;

    hardware.graphics.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
    };

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