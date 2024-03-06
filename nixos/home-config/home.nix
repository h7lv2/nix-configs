{ config, pkgs, ... }:

{
  home.username = "eli";
  home.homeDirectory = "/home/eli";

  home.packages = with pkgs; [
    # browsers
    firefox
    vivaldi

    # launchers
    gnome.gnome-software
    
    # text editors 
    kate
    vscode.fhs

    # daemon-ish stuff?
    syncthing
    syncthingtray

    # language servers
    nil
  ];

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
