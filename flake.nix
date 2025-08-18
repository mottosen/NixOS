{
  description = "Nix flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }: 
    let
      profile = "pc";
      system = "x86_64-linux";

      lib = nixpkgs.lib;
    in
    {
    nixosConfigurations = {
      system = lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/hardware
          ./modules/software
        ];
        specialArgs = {
          inherit profile;
          inherit system;
        };
      };
    };
  };
}
