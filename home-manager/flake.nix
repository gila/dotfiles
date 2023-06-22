{
  description = "Home Manager configuration of gila";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, flake-utils }:
    let
      username = "gila";
      #system = "aarch64-darwin";
      #pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."m1" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        modules = [
        {

          home.username = "${username}";
          home.homeDirectory = "/home/${username}";
          home.stateVersion = "23.05";
          }
          ./home.nix

        ];
      };

      homeConfigurations."gila" = home-manager.lib.homeManagerConfiguration {
        modules = [ ./home.nix ];
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };
    };
}
