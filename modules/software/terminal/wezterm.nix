{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.userSettings.terminal == "wezterm") {
    environment.systemPackages = with pkgs; [ wezterm ];
  };
}
