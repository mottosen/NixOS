{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.userSettings.terminal == "kitty") {
    environment.systemPackages = with pkgs; [
      kitty
    ];
  };
}
