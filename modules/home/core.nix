{ ... }:

{
  home.username = "dries";
  home.homeDirectory = "/home/dries";
  home.stateVersion = "26.05";

  programs.bash = {
    enable = true;
    shellAliases = {
      nix-switch = "nh os switch";
      nix-test = "nh os test";
      nix-clean = "nh clean all --keep 5";
    };
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg.configFile."kitty/kitty.conf".source = ../../dotfiles/kitty/kitty.conf;
  xdg.configFile."fastfetch/config.jsonc".source = ../../dotfiles/fastfetch/config.jsonc;
}