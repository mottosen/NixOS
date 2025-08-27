{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (lib.elem config.userSettings.editor [ "vim" "nvim" "neovim" ]) {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
