{ config, lib, ... }:

{
  imports = [
    ../../.definitions
  ];

  config = lib.mkIf (config.systemSettings.profile == "viking") {
    systemSettings = {
      hostname = "nixos";
      timezone = "Europe/Copenhagen";
      bootloader = "bios";
      systemDevice = "/dev/sda";
    };

    userSettings = {
      username = "marius";
      name = "marius";
      email = "marius@test.com";
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
