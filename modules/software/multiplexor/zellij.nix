{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.userSettings.multiplexor == "zellij") {
    environment.systemPackages = with pkgs; [ zellij ];
  };
}
