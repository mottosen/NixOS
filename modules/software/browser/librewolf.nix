{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.userSettings.browser == "librewolf") {
    environment.systemPackages = [
      (pkgs.librewolf.override {
        extraPrefsFiles = [
          (pkgs.writeText "librewolf-dark-prefs.js" ''
            // Force dark theme for web content (prefers-color-scheme: dark)
            pref("ui.systemUsesDarkTheme", 1);
            // 0 = dark, 1 = light, 2 = system
            pref("layout.css.prefers-color-scheme.content-override", 0);
            // Allow prefers-color-scheme through resistFingerprinting
            pref("privacy.resistFingerprinting.overrides", "+prefers-color-scheme");
            // Dark scrollbars
            pref("widget.non-native-theme.scrollbar.style", 5);
          '')
        ];
      })
    ];

    environment.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };
  };
}
