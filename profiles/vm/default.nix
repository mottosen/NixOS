{ config, lib, ... }:

{
  imports = [
    ../../.definitions
  ];

  config = lib.mkIf (config.systemSettings.profile == "vm") {
    systemSettings = {
      hostname = "nixos-vm";
      timezone = "Europe/Copenhagen";
      bootloader = "bios";
      systemDevice = "/dev/sda";
    };

    userSettings = {
      username = "test"; # host mounted dir depends on this
      name = "test user";
      email = "test@vm.com";
      windowManager = "qtile";
      browser = "zen";
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
