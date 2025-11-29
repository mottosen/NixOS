{
  description = "Nix flake";

  inputs = {
        #nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    matugen.url = "github:/InioX/Matugen";
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in
    {
    nixosConfigurations = {
      vm = lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/hardware
          ./modules/software
        ];
        specialArgs = {
          profile = "vm";
          inherit system;
          inherit inputs;
        };
      };

      viking = lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/hardware
          ./modules/software
        ];
        specialArgs = {
          profile = "viking";
          inherit system;
          inherit inputs;
        };
      };

      framework = lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/hardware
          ./modules/software
        ];
        specialArgs = {
          profile = "framework";
          inherit system;
          inherit inputs;
        };
      };

      dell = lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/hardware
          ./modules/software
        ];
        specialArgs = {
          profile = "dell";
          inherit system;
          inherit inputs;
        };
      };
    };
  };
}
