{ pkgs, lib, ... }:

{
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_6_18;

  specialisation.linux-latest.configuration = {
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  };
}
