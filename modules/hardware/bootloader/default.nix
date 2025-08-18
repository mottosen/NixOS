{ config, ... }:

{
  imports = [
    ./efi.nix
    ./bios.nix
    ./bios-libreboot.nix
  ];
}
