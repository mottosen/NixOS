{ config, lib, ... }:

{
  config = lib.mkIf (config.systemSettings.profile == "viking") { };
}
