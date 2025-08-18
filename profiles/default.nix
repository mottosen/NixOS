{ config, profile, system, ... }:

{
  imports = [
    ./vm
    ./viking
  ];

  config.systemSettings.profile = profile;
  config.systemSettings.architecture = system;
}
