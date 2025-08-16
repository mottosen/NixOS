{ config, lib, ... }:

{
  config = lib.mkIf (config.systemSettings.kernel != "") {
    boot.kernelPackages = lib.mkForce config.systemSettings.kernel;
  };
}
