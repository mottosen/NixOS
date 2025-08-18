{ config, lib, ... }:

{
  imports = [
    ../../.definitions
  ];

  config = lib.mkIf (config.systemSettings.profile == "pc") {
    systemSettings = {
      hostname = "nixos-pc";
      timezone = "Europe/Copenhagen";
    };

    userSettings = {
      username = "marius";
      name = "Marius";
      email = "business@mottosen.xyz";
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
