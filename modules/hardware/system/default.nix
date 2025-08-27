{ config, ... }:

{
  imports = [
    ./vm.nix
    ./framework.nix
    ./viking.nix
    ./dell.nix
  ];
}
