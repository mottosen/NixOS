{ config, pkgs, lib, ... }:

{
    config = {
        environment.systemPackages = with pkgs; [
            nodejs
            npm
            bash-language-server
        ];
    };
}
