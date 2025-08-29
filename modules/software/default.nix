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
    ./browser
    ./zsa
  ];

  # General
  system.stateVersion = "25.05"; # Do not change
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.logind.lidSwitchDocked = "suspend";

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
    wireless = {
      enable = false;
      iwd.enable = true;
    };
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };

  # Baseline terminal
  users.defaultUserShell = pkgs.bash;
  environment = {
    shells = with pkgs; [ bash zsh ];
    sessionVariables = {
      EDITOR   = config.userSettings.editor;
      VISUAL   = config.userSettings.editor;
      TERMINAL = config.userSettings.terminal;
    };
  };

  # Fonts
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.symbols-only
      nerd-fonts.fira-code
      nerd-fonts.hurmit
      nerd-fonts.intone-mono
    ];
  };

  # X11 stuff
  services.xserver = {
    enable = true;
    windowManager.qtile.enable = true;
    videoDrivers = [ "amdgpu" "modesetting" ];
  };

  # User Setup
  users.users."${user}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "plugdev" ];
    initialPassword = "1234";
  };

  # System wide packages
  nixpkgs.config.allowUnfree = true;
  programs.firefox.enable = true;
  services = {
    blueman.enable = true;
    pcscd.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    stow
    fastfetch
    fzf
    pik
    btop
    killall
    ranger
    feh
    keymapp
    libnotify
    brightnessctl
    mako
    yubioath-flutter
    diff-so-fancy
  ];
}
