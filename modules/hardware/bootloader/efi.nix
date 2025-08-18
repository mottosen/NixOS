{ config, lib, ... }:

{
  config = lib.mkIf (config.systemSettings.bootloader == "efi") {
    boot.loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = config.systemSettings.bootMountPath;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      grub = {
        enable = true;
        device = "nodev";
      };
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
  };
}
