{ config, lib, ... }:

{
  config = lib.mkIf (config.systemSettings.bootloader == "bios-libreboot") {
    boot.loader = {
      grub = {
        enable = true;
        device = config.systemSettings.systemDevice;
        fsIdentifier = "label";
      };
    };

    environment.etc."grub/libreboot-chain.cfg".text = ''
      search --file --set=root /boot/grub/grub.cfg
      configfile /boot/grub/grub.cfg
    '';

    system.activationScripts.librebootChain.text = ''
      mkdir -p /grub
      install -m0644 /etc/grub/libreboot-chain.cfg /grub/grub.cfg
    '';
  };
}
