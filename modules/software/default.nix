{ config, lib, pkgs, ... }:

let
  user = config.userSettings.username;
in
{
  imports = [
     ../../profiles
    ./editor
    ./multiplexor
    ./shell
    ./terminal
    ./windowManager
    ./browser
  ];

  # General
  system.stateVersion = "25.05"; # Do not change
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    download-buffer-size = 134217728; # 128 MB (default is 64 MB)
  };

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
#     extraHosts = ''
# 127.0.0.1 local.appstract.cloud
#     '';
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

  # zsa keyboard stuff
  users.groups.plugdev = {};
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "zsa_voyager";
      destination = "/etc/udev/rules.d/50-zsa.rules";
      text = ''
# Rules for Oryx web flashing and live training
KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

# Keymapp Flashing rules for the Voyager
SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
      '';
    })
  ];

  # User Setup
  users.users."${user}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" "video" "seat" "plugdev" "libvirtd" "docker" ];
    initialPassword = "1234";
  };

  # System wide packages
  nixpkgs.config.allowUnfree = true;
  virtualisation.docker = {
        enable = true;
        #extraOptions = "--bip=192.168.100.1/24 --fixed-cidr=192.168.100.0/24 --dns=8.8.8.8 --dns=8.8.4.4";
  };
  services = {
    displayManager.gdm.enable = true;
    blueman.enable = true;
    pcscd.enable = true;
    logind = {
      settings.Login.HandleLidSwitchDocked = "suspend";
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
  programs = {
    firefox.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # cli
    busybox
    curl
    devbox
    fastfetch
    fzf
    gnumake
    ripgrep
    stow
    uair # pomodoro timer cli
    wget # full install needed for TLS support

    # tui
    btop
    lazydocker
    ranger
    vim

    # gui
    feh # image viewer
    geteduroam
    keymapp # zsa keyboard tool
    vscode
    yubioath-flutter
    zotero

    # utility
    brightnessctl # screeb brightness
    bibata-cursors
    libnotify # notification utility
    libinput # input devices
    mako # notification service
    pik # kill processes

    # git
    diff-so-fancy # pretty print file diff
    git
    lazygit

    # languages
    cmake
    gcc
    lua
    python3

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
