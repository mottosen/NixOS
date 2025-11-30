{ ... }:

{
  config = {
    programs = {
      neovim = {
        enable = true;
        defaultEditor = true;
      };
    };

    environment.systemPackages = [ ];
  };
}
