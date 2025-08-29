{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.userSettings.browser == "librewolf") {
    environment.systemPackages = with pkgs; [
      librewolf
    ];
  };
}
