{ config, lib, pkgs, ... }:

{
  imports = [
    ./systemSettings.nix
    ./userSettings.nix
  ];
}
