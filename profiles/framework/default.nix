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
      systemDevice = "/dev/nvme0n1";
    };

    userSettings = {
      username = "marius";
      name = "marius";
      email = "marius@test.com";
      windowManager = "hypr";
      browser = "librewolf";
      terminal = "wezterm";
      multiplexor = "zellij";
      shell = "zsh";
      shellAliases = {
        la = "ls -al --color";
        zz = "zellij attach -c";
        vim = "nvim";
        py = "python3";
        gs = "git status --short";
        lg = "lazygit";
        vh = "vim .";
      };
    };
  };
}
