{ config, lib, pkgs, ... }:

{
  imports = [
    ../../profiles
    ./bootloader
    ./system
    ./kernel
  ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault config.systemSettings.architecture;

  hardware = {
    graphics.enable = lib.mkDefault true;
    enableRedistributableFirmware = lib.mkDefault true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/swapfile"; size = 2048; }
  ];
}
