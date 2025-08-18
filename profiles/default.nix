{ config, profile, system, ... }:

{
  imports = [
    ./vm
    ./pc-old
  ];

  config.systemSettings.profile = profile;
  config.systemSettings.architecture = system;
}
