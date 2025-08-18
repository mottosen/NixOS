update-flake:
    nix flake update

update-system:
    sudo nixos-rebuild switch --flake .#system
