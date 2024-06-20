{ config, pkgs, ... }:
{
  home.username = "eli";
  home.homeDirectory = "/home/eli";

  systemd.user.sessionVariables = { 
    editor = "hx";
  };

  home.packages = with pkgs; [
    clinfo
    element-desktop
    firefox
    # floorp
    glxinfo
    keepassxc
    localsend
    moonlight-qt
    obs-studio
    nekoray
    spotify
    syncthingtray
    telegram-desktop
    vesktop
    vscode-fhs
    vulkan-tools
    wayland-utils
    yt-dlp
 ];

  home.pointerCursor = {
    package = pkgs.kdePackages.breeze;
    gtk.enable = true;
    x11.enable = true;
    
    name = "breeze_cursors";
    size = 24;
  };

  programs.git = {
    enable = true;
    userEmail = "xolagix@outlook.com";
    userName = "halva (h7lv2)";
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = [ pkgs.nil ];
    settings = {
      theme = "onedark";
      editor = {
        line-number = "relative";
        mouse = false;
        lsp.display-messages = true;
      };
    };
  };

  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "hx";
    };
  };

  services.syncthing = {
    enable = true;
  };

  # xdg.desktopEntries = {
  #   vesktop = {
  #     name = "Vesktop";
  #     icon = "/$(pkgs.vesktop)/share/icons/hicolor/1024x1024/apps/vesktop.png";
  #     genericName = "Internet Messenger";
  #     exec = "vesktop %U --ozone-platform=wayland";
  #     terminal = false;
  #     categories = [ "Network" "InstantMessaging" "Chat" ];
  #     type = "Application";
  #   };
  # };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
