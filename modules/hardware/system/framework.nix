{ config, lib, ... }:

let
  user = config.userSettings.username;
in
{
  config = lib.mkIf (config.systemSettings.profile == "framework") {
  };
}
