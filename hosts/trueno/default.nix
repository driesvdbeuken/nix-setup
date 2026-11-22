{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  modules.nixos = {
    desktop.niri.enable = true;
  };
}