{ config, ... }:

{
  imports = [
    ./efi.nix
    ./bios.nix
  ];
}
