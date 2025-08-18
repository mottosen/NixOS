{ config, lib, ... }:

{
  config = lib.mkIf (config.systemSettings.bootloader == "bios") {
    boot.loader = {
      grub = {
        enable = true;
        device = config.systemSettings.systemDevice;
        fsIdentifier = "label";
      };
    };
  };
}
