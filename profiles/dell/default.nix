{ config, lib, ... }:

{
  imports = [
    ../../.definitions
  ];

  config = lib.mkIf (config.systemSettings.profile == "dell") {
    systemSettings = {
      hostname = "dell";
      timezone = "Europe/Copenhagen";
      bootloader = "efi";
      systemDevice = "/dev/nvme0n1";
    };

    userSettings = {
      username = "marius";
      name = "marius";
      email = "marius@test.com";
      windowManager = "hypr";
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
