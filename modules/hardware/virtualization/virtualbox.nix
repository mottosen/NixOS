{ config, lib, ... }:

{
  config = lib.mkIf (config.systemSettings.profile == "vm") {
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

    virtualisation.virtualbox.guest.enable = true;
  };
}
