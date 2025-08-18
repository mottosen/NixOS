{
  description = "Nix flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }: 
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
        };
      };
    };
  };
}
