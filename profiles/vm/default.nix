{ config, lib, ... }:

{
  imports = [
    ../../.definitions
  ];

  config = lib.mkIf (config.systemSettings.profile == "vm") {
    systemSettings = {
      hostname = "nixos-vm";
      timezone = "Europe/Copenhagen";
      bootloader = "efi";
      systemDevice = "/dev/sda";
    };

    userSettings = {
      username = "test"; # host mounted dir depends on this
      name = "test user";
      email = "test@vm.com";
      windowManager = "qtile";
      browser = "librewolf";
      terminal = "wezterm";
      multiplexor = "zellij";
      shell = "zsh";
      shellAliases = {
        la = "ls -al --color";
        zz = "zellij attach -c";
        vim = "nvim";
        py = "python3";
      };
    };
  };
}
