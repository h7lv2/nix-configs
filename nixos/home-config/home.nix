{ config, pkgs, ... }:

{
  home.username = "eli";
  home.homeDirectory = "/home/eli";

  home.packages = with pkgs; [
    # browsers
    firefox
    chromium
            
    # launchers
    libsForQt5.discover
    
    # text editors 
    kate
    vscode.fhs

    # daemon-ish stuff?
    syncthing
    syncthingtray

    # language servers
    nil
  ];

  # make chromium prefer wayland (it doesnt by default for some reason??)
  xdg.desktopEntries.chromium = {
    type = "Application";
    exec = "chromium %U --ozone-platform-hint=auto";
    icon = "${pkgs.chromium}/share/icons/hicolor/256x256/apps/chromium.png";
    terminal = false;
    name = "Chromium";
    genericName = "Web Browser";
    mimeType = [ "application/pdf" "application/rdf+xml" "application/rss+xml" "application/xhtml+xml" "application/xhtml_xml" "application/xml" "image/gif" "image/jpeg" "image/png" "image/webp" "text/html" "text/xml" "x-scheme-handler/http" "x-scheme-handler/https" "x-scheme-handler/webcal" "x-scheme-handler/mailto" "x-scheme-handler/about" "x-scheme-handler/unknown" ];
    categories = [ "Application" "Network" "WebBrowser" ];
    prefersNonDefaultGPU = false;
  }; 
      
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
