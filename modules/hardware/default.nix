{ config, lib, pkgs, ... }:

{
  imports = [ ../../profiles ./bootloader ./system ./kernel ];

  boot.tmp.useTmpfs = true;
  # mkfs/mount tooling + kernel modules; covers all fs in use plus xfs.
  # xfs (new), ext4 (root /), vfat (EFI /boot), fuse (sshfs remote mounts)
  boot.supportedFilesystems = [ "xfs" "ext4" "vfat" "fuse" ];
  # setuid fusermount3 wrapper; required for non-root sshfs mounts
  programs.fuse.enable = true;
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault config.systemSettings.architecture;
  security.rtkit.enable = true; # realtime scheduler, used by Pipewire

  hardware = {
    graphics.enable = lib.mkDefault true;
    enableRedistributableFirmware = lib.mkDefault true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy = { AutoEnable = true; };
      };
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [{
    device = "/swapfile";
    size = 2048;
  }];
}
