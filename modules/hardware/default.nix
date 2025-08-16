{ config, lib, pkgs, ... }:

{
  imports = [
    ../../profiles
    ./virtualization
    ./kernel
  ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelModules = [ ];
    extraModulePackages = [ ];

    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = config.systemSettings.bootMountPath;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    };

    initrd = {
      availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [
    { device = "/swapfile"; size = 2048; }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = config.systemSettings.architecture;
}
