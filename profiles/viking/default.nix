{ config, lib, ... }:

{
  imports = [ ../../.definitions ];

  config = lib.mkIf (config.systemSettings.profile == "viking") {
    systemSettings = {
      hostname = "nixos";
      timezone = "Europe/Copenhagen";
      bootloader = "bios-libreboot";
      systemDevice = "nodev";
    };

    userSettings = {
      username = "marius";
      name = "marius";
      email = "marius@test.com";
      windowManager = "qtile";
      browser = "librewolf";
      terminal = "kitty";
      multiplexor = "zellij";
      shell = "zsh";
    };
  };
}
