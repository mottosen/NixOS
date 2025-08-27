{ config, lib, ... }:

let
  user = config.userSettings.username;
in
{
  config = lib.mkIf (config.systemSettings.profile == "dell") {
    boot = {
      kernelModules = [ "kvm-intel" ];
      initrd = {
        availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      };
    };

    hardware = {
      cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
  };
}
