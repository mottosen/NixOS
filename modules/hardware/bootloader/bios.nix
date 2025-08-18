{ config, lib, ... }:

{
  config = lib.mkIf (config.systemSettings.bootloader == "bios") {
    boot.loader = {
      systemd-boot.enable = false;
      grub = {
        enable = true;
        device = config.systemSettings.systemDevice;
      };
    };
  };
}
