{ config, pkgs, lib, inputs, system, ... }:

{
  config = lib.mkIf (config.userSettings.browser == "zen") {
    environment.systemPackages = with pkgs; [
      inputs.zen-browser.packages."${system}".default
    ];
  };
}
