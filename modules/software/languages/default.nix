{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gcc
    cmake
    lua
    python3
  ];
}
