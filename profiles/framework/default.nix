{ config, lib, ... }:

{
  imports = [
    ../../.definitions
  ];

  config = lib.mkIf (config.systemSettings.profile == "framework") {
    systemSettings = {
      hostname = "framework";
      timezone = "Europe/Copenhagen";
      bootloader = "efi";
      systemDevice = "/dev/nvme1n1";
    };

    userSettings = {
      username = "marius";
      name = "marius";
      email = "marius@test.com";
      windowManager = "hypr";
      browser = "librewolf";
      terminal = "kitty";
      multiplexor = "zellij";
      shell = "zsh";
    };
  };
}
