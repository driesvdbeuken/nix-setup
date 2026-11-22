{ config, lib, pkgs, ... }:

let
  cfg = config.modules.nixos.nvidia;
in
{
  options.modules.nixos.nvidia = {
    enable = lib.mkEnableOption "NVIDIA GPU drivers";

    legacyPascal = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use legacy 580 proprietary driver branch required for Pascal GPUs (e.g. MX350).";
    };

    prime = {
      enable = lib.mkEnableOption "NVIDIA PRIME hybrid offload (for laptops with Intel iGPU)";

      intelBusId = lib.mkOption {
        type = lib.types.str;
        default = "PCI:0:2:0";
        description = "PCI bus ID of the integrated Intel GPU.";
      };

      nvidiaBusId = lib.mkOption {
        type = lib.types.str;
        default = "PCI:1:0:0";
        description = "PCI bus ID of the discrete NVIDIA GPU.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers =
      if cfg.prime.enable then [ "modesetting" "nvidia" ] else [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;

      # Pascal (MX350) requires proprietary modules + legacy_580; Ampere (RTX 3050) uses latest + open modules
      open = !cfg.legacyPascal;
      branch = lib.mkIf cfg.legacyPascal "legacy_580";

      powerManagement.enable = true;
      powerManagement.finegrained = cfg.prime.enable;

      nvidiaSettings = true;

      prime = lib.mkIf cfg.prime.enable {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = cfg.prime.intelBusId;
        nvidiaBusId = cfg.prime.nvidiaBusId;
      };
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.full
    ];
  };
}