{ config, pkgs, lib, ... }:

let
  user = config.userSettings.username;
in
{
  config = lib.mkIf (config.userSettings.shell == "zsh") {
    programs.zsh = {
      enable = true;
      shellAliases = config.userSettings.shellAliases;
    };

    users.users."${user}".shell = pkgs.zsh;

    environment.systemPackages = with pkgs; [
      oh-my-posh
      zoxide
    ];
  };
}
