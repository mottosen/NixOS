{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.userSettings.windowManager == "hypr") {
    programs.hyprland.enable = true;
    programs.waybar.enable = true;

    environment.systemPackages = with pkgs; [
      wofi
      libsForQt5.dolphin
    ];

    # Input/session management for Wayland compositors
    services.seatd.enable = true;                 # Hyprland can use seatd or logind
    security.polkit.enable = true;

    # Portals (screen sharing, open dialog etc.)
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
  };
}
