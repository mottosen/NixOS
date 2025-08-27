{ config, profile, system, ... }:

{
  imports = [
    ./vm
    ./viking
    ./dell
  ];

  config.systemSettings.profile = profile;
  config.systemSettings.architecture = system;
}
