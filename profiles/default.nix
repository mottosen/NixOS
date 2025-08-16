{ config, profile, system, ... }:

{
  imports = [
    ./vm
  ];

  config.systemSettings.profile = profile;
  config.systemSettings.architecture = system;
}
