{
  description = "Nix flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    matugen.url = "github:/InioX/Matugen";
    pwndbg.url = "github:pwndbg/pwndbg";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, pwndbg, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    in {
      nixosConfigurations = {
        vm = lib.nixosSystem {
          inherit system;
          modules = [ ./modules/hardware ./modules/software ];
          specialArgs = {
            profile = "vm";
            inherit system inputs pkgs-unstable;
          };
        };

        viking = lib.nixosSystem {
          inherit system;
          modules = [ ./modules/hardware ./modules/software ];
          specialArgs = {
            profile = "viking";
            inherit system inputs pkgs-unstable;
          };
        };

        framework = lib.nixosSystem {
          inherit system;
          modules = [ ./modules/hardware ./modules/software ];
          specialArgs = {
            profile = "framework";
            inherit system inputs pkgs-unstable;
          };
        };

        dell = lib.nixosSystem {
          inherit system;
          modules = [ ./modules/hardware ./modules/software ];
          specialArgs = {
            profile = "dell";
            inherit system inputs pkgs-unstable;
          };
        };
      };
    };
}
