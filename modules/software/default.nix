{ config, lib, pkgs, ... }:

let
  user = config.userSettings.username;
in
{
  imports = [
     ../../profiles
    ./editor
    ./languages
    ./multiplexor
    ./shell
    ./terminal
    ./windowManager
  ];

  # General
  system.stateVersion = "25.05"; # Do not change
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  # Location and Network
  time.timeZone = config.systemSettings.timezone;
  i18n.defaultLocale = config.systemSettings.locale;
  networking = {
    hostName = config.systemSettings.hostname;
    networkmanager.enable = true;
  };

  # System wide packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    stow
    fastfetch
  ];

  # Baseline terminal
  users.defaultUserShell = pkgs.bash;
  environment = {
    shells = with pkgs; [ bash zsh ];
    sessionVariables = {
      EDITOR   = config.userSettings.editor;
      VISUAL   = config.userSettings.editor;
      TERMINAL = config.userSettings.terminal;

      # VM ?
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      WLR_NO_HARDWARE_CURSORS = 1;
      WLR_RENDERER_ALLOW_SOFTWARE = 1;   # let it fall back to llvmpipe if needed
    };
  };

  # Fonts
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
    ];
  };

  # TODOTODO: consider
  services.xserver = {
    enable = true;
    windowManager.qtile.enable = true;
  };

  # User Setup
  users.users."${user}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "vboxsf" ];
  };
}
