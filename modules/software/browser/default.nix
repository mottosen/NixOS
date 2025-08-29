{ config, pkgs, ... }:

{
  imports = [
    ./zen.nix
    ./librewolf.nix
  ];
}
