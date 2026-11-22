{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  modules.nixos = {
    desktop.niri.enable = true;
    nvidia = {
      enable = true;
      legacyPascal = true;
      prime = {
        enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:2:0:0";
      };
    };
  };
}