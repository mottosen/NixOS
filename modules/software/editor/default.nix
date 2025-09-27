{ config, pkgs, ... }:

{
  imports = [
    ./nvim.nix
    ./vscode.nix
  ];
}
