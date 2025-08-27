{ config, lib, ... }:

let
  user = config.userSettings.username;
in
{
  config = lib.mkIf (config.systemSettings.profile == "vm") {
    boot = {
      initrd = {
        availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
      };
    };

    virtualisation.virtualbox.guest.enable = true;

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = 1;
      WLR_RENDERER_ALLOW_SOFTWARE = 1;
    };

    services.xserver.videoDrivers = [ "vmware" ];

    users.users."${user}" = {
      extraGroups = [ "vboxsf" ];
    };

    systemd.tmpfiles.rules = [
      "d /home/test/.dotfiles 0755 $USER users -"
      "d /home/test/nixos 0755 $USER users -"
    ];

    fileSystems."/home/test/nixos" = {
      device = "nixos";
      fsType = "vboxsf";
      options = [
        "rw"
        "uid=1000"
        "gid=100"
        "dmode=0755"
        "fmode=0644"
        "noauto"
        "x-systemd.automount"
        "nofail"
      ];
    };

    fileSystems."/home/test/.dotfiles" = {
      device = "dotfiles";
      fsType = "vboxsf";
      options = [
        "rw"
        "uid=1000"
        "gid=100"
        "dmode=0755"
        "fmode=0644"
        "noauto"
        "x-systemd.automount"
        "nofail"
      ];
    };
  };
}
