{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vlc
    obsidian
    chromium
    libreoffice
    kitty
  ];

  services.flatpak = {
    enable = true;
    packages = [
      "net.waterfox.waterfox"
      "org.localsend.localsend_app"
    ];
  };
}