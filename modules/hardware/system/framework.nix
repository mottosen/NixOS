{ config, lib, modulesPath, ... }:

let
  user = config.userSettings.username;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = lib.mkIf (config.systemSettings.profile == "framework") {
    boot = {
      kernelModules = [ "kvm-amd" ];
      initrd = {
        availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "usbhid" "sd_mod" ];
      };
    };

    hardware = {
      cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
  };
}
