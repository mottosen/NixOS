{ config, lib, pkgs, ... }:

{
  imports = [
    ../../profiles
    ./bootloader
    ./virtualization
    ./kernel
  ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelModules = [];
    extraModulePackages = [];

    initrd = {
      availableKernelModules = [ "vmd" "nvme" "xhci_pci" "usb_storage" "rtsx_pci_sdmmc" "sdhci_pci" "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
      kernelModules = [];
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/swapfile"; size = 2048; }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = config.systemSettings.architecture;
  hardware.graphics.enable = true;
}
