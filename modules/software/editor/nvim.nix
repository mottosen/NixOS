{ pkgs, pkgs-unstable, ... }:

{
  config = {
    programs = {
      neovim = {
        enable = true;
        defaultEditor = true;
        package = pkgs-unstable.neovim-unwrapped;
      };
    };

    environment.systemPackages = with pkgs; [
      # --- LSP ---
      asm-lsp

      # --- Format ---
      black
      clang-tools
    ];
  };
}
