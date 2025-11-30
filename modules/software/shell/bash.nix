{ config, pkgs, lib, ... }:

let user = config.userSettings.username;
in {
  config = lib.mkIf (config.userSettings.shell == "bash") {
    programs.bash = {
      enable = true;
      shellAliases = config.userSettings.shellAliases;
    };
    users.users."${user}".shell = pkgs.bash;
  };
}
