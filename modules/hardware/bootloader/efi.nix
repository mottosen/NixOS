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
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };
}
