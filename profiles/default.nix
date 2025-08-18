{ config, profile, system, ... }:

{
  imports = [
    ./vm
    ./viking
    ./framework
  ];

  config.systemSettings.profile = profile;
  config.systemSettings.architecture = system;
}
