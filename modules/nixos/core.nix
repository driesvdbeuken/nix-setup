{ pkgs, hostName, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = hostName;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  console.keyMap = "us";

  # Universal display manager & keyring unlock across all hosts
  services.displayManager.gdm.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  users.users.dries = {
    isNormalUser = true;
    description = "Dries";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.bash;
  };

  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 5";
    flake = "/etc/nixos";
  };
  nix.settings.auto-optimise-store = true;

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    fastfetch
  ];

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;

  system.stateVersion = "26.05";
}