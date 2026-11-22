{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  modules.nixos = {
    gaming.enable = true;
    desktop.gnome.enable = true;
    # desktop.cosmic.enable = true;
    nvidia.enable = true;
  };
}