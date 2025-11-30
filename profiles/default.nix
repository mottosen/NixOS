{ profile, system, ... }:

{
  imports = [ ./vm ./framework ./viking ./dell ];

  config.systemSettings.profile = profile;
  config.systemSettings.architecture = system;
}
