{
  config,
  pkgs,
  lib,
  ...
}:

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
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    download-buffer-size = 134217728; # 128 MB (default is 64 MB)
  };

  # Enable nix-ld to run dynamically linked executables (needed for Mason LSP servers)
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ dotnet-sdk_9 ];
  };

  # VMs
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  # Garbage Collection
  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

  # Location and Network
  time.timeZone = config.systemSettings.timezone;
  i18n.defaultLocale = config.systemSettings.locale;
  networking = {
    hostName = config.systemSettings.hostname;
    networkmanager = {
      enable = true;
      wifi.backend = "wpa_supplicant";
    };
    extraHosts = ''
      127.0.0.2 local.appstract.cloud
      127.0.0.1 thephyllosopher.com
    '';
  };

  # Baseline terminal
  users.defaultUserShell = pkgs.bash;
  environment = {
    shells = with pkgs; [
      bash
      zsh
    ];
    sessionVariables = {
      EDITOR = config.userSettings.editor;
      VISUAL = config.userSettings.editor;
      TERMINAL = config.userSettings.terminal;
      GTK_THEME = "Adwaita:dark";
      QT_STYLE_OVERRIDE = "Adwaita-Dark";
      # Make dotnet available to Mason-installed tools
      DOTNET_ROOT = "${pkgs.dotnet-sdk_9}/share/dotnet";
      # Set timezone for applications (helps with Electron apps like Discord)
      TZ = config.systemSettings.timezone;
      # Additional dark theme preferences
      GTK_THEME_VARIANT = "dark";
      QT_QPA_PLATFORMTHEME = "gtk3";
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
    videoDrivers = [
      "amdgpu"
      "modesetting"
    ];
  };

  # zsa keyboard stuff
  users.groups.plugdev = { };
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
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
      "video"
      "seat"
      "plugdev"
      "libvirtd"
      "docker"
    ];
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

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-theme = "Adwaita-dark";
          };
        };
      }
    ];
  };

  # GTK dark theme configuration
  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
  '';

  # GTK 4 dark theme configuration
  environment.etc."xdg/gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
  '';

  environment.systemPackages = with pkgs; [
    # cli
    busybox
    cargo
    curl
    devbox
    fastfetch
    fzf
    gnumake
    gdb
    nvme-cli
    proton-vpn-cli
    radare2
    ripgrep
    sshfs
    stow
    uair
    wget # busybox install not enough
    zip

    # tui
    btop
    claude-code
    github-copilot-cli
    lazydocker
    ranger
    vim

    # gui
    firefox
    geteduroam
    keymapp
    obsidian
    feh
    vscode
    yubioath-flutter
    zotero

    # utility
    brightnessctl
    bibata-cursors
    libnotify
    libinput
    mako
    pik

    # git
    diff-so-fancy
    git
    lazygit

    # languages
    cmake
    clang
    gcc
    lua
    python3
    go
    nodejs
    dotnet-sdk_9

    # vm stuff
    qemu
    quickemu
    (writeShellScriptBin "qemu-system-x86_64-uefi" ''
      qemu-system-x86_64 -bios ${pkgs.OVMF.fd}/FV/OVMF.fd "$@"
    '')
  ];
}
