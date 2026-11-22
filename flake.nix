{
  description = "Modular NixOS & Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-flatpak, home-manager, ... }@inputs:
    let
      mkSystem = hostName:
        let
          system = "x86_64-linux";
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hostName pkgs-unstable; };
          modules = [
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            ./hosts/${hostName}
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs hostName pkgs-unstable; };
                users.dries = import ./modules/home;
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        skyline = mkSystem "skyline";
        trueno = mkSystem "trueno";
        silvia = mkSystem "silvia";
      };
    };
}