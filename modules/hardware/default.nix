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
    kernelModules = [ "kvm-intel" ]; # dell
    #kernelModules = [ "amdgpu" ];
    extraModulePackages = [];

    initrd = {
      availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ]; # vm
      availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ]; # dell

      kernelModules = [];
      #kernelModules = [ "i915" "amdgpu" ];
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

  hardware = {
    graphics.enable = true;
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
