{ config, pkgs, ... }:

{
  home.username = "eli";
  home.homeDirectory = "/home/eli";

  home.packages = with pkgs; [
    firefox
    vivaldi
    kate
    syncthingtray
    vscode.fhs
    nil
  ];

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
