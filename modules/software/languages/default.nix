{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gcc
    cmake
    lua
    python3
    dotnetCorePackages.dotnet_9.sdk
    dotnetCorePackages.runtime_9_0-bin
  ];
}
