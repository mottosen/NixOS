{ config, pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./zsh.nix
  ];
}
