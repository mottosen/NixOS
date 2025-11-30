{ config, lib, inputs, system, ... }:

{
  config = lib.mkIf (config.userSettings.browser == "zen") {
    environment.systemPackages =
      [ inputs.zen-browser.packages."${system}".default ];
  };
}
