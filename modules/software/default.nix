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

  # VMs
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

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
    wireless.enable = false;
    networkmanager = {
      enable = true;
      wifi.backend = "wpa_supplicant";
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
    displayManager.gdm.enable = true;
    windowManager.qtile.enable = true;
    videoDrivers = [ "amdgpu" "modesetting" ];
  };

  # User Setup
  users.users."${user}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" "video" "seat" "plugdev" "libvirtd" "docker" ];
    initialPassword = "1234";
  };

  # System wide packages
  nixpkgs.config.allowUnfree = true;
  programs.firefox.enable = true;
  virtualisation.docker = {
        enable = true;
        #extraOptions = "--bip=192.168.100.1/24 --fixed-cidr=192.168.100.0/24 --dns=8.8.8.8 --dns=8.8.4.4";
  };
  services = {
    blueman.enable = true;
    pcscd.enable = true;
    logind = {
      lidSwitchDocked = "suspend";
    };
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
    # cli
    busybox
    curl
    stow
    fastfetch
    fzf
    uair # pomodoro timer cli
    gnumake

    # tui
    ranger
    btop
    vim
    lazydocker

    # gui
    feh # image viewer
    keymapp # zsa keyboard tool
    yubioath-flutter
    zotero
    geteduroam

    # utility
    libnotify # notification utility
    libinput # input devices
    brightnessctl # screeb brightness
    pik # kill processes
    mako # notification service
    bibata-cursors

    # git
    git
    diff-so-fancy # pretty print file diff
    lazygit

    # vm stuff
    qemu
    quickemu
    (
      writeShellScriptBin "qemu-system-x86_64-uefi" ''
        qemu-system-x86_64 -bios ${pkgs.OVMF.fd}/FV/OVMF.fd "$@"
      ''
    )
  ];
}
