{ config, lib, ... }:

{
  imports = [ ../../.definitions ];

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
      windowManager = "hypr";
      browser = "librewolf";
      terminal = "kitty";
      multiplexor = "zellij";
      shell = "zsh";
    };
  };
}
