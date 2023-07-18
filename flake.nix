{
  description = "Perf tools nix packages";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-23.05";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    home-manager,
    nixpkgs,
    darwin,
  }: let
    allSystems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];

    overlay = f: p: {
      fio = f.callPackage ./nix/fio.nix {};
    };

    forAllSystems = f:
      nixpkgs.lib.genAttrs allSystems
      (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [overlay];
          };
        });
  in {
    h = forAllSystems ({pkgs}: {
      ubuntu = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home.homeDirectory = "/home/ubuntu";
            home.username = "ubuntu";
            home.stateVersion = "23.05";
          }
          ./nix/home.nix
        ];
      };
      gila = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home.homeDirectory = "/home/gila";
            home.username = "gila";
            home.stateVersion = "23.05";
          }
          ./nix/home.nix
        ];
      };
    });

    darwinConfigurations = {
      m2 = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          ./nix/darwin-configuration.nix
        ];
      };
    };

    formatter = forAllSystems ({pkgs}: pkgs.alejandra);
    packages = forAllSystems ({pkgs}: {
      fio = pkgs.fio;

      ubuntu = self.h.${pkgs.system}.ubuntu.activationPackage;
      gila = self.h.${pkgs.system}.gila.activationPackage;
    });

    devShells = forAllSystems ({pkgs}: {
      default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [fio];
      };
    });
  };
}
