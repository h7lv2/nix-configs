{ config, pkgs, ... }:
{
  home.username = "eli";
  home.homeDirectory = "/home/eli";

  systemd.user.sessionVariables = { 
    editor = "hx";
  };

  home.packages = with pkgs; [
    clinfo
    bitwarden-desktop
    discord-canary
    dosbox-staging
    element-desktop
    firefox
    firefoxpwa
    floorp
    glxinfo
    keepassxc
    krita
    libreoffice-qt6-fresh
    hunspellDicts.ru_RU # society if home-manager had extraPackages for libreoffice
    localsend
    moonlight-qt
    nekoray
    obs-studio
    signal-desktop
    spotify
    syncthingtray
    telegram-desktop
    vscode-fhs
    vulkan-tools
    wayland-utils
    yt-dlp
  ];

  programs.firefox.package = pkgs.firefox.override {
    nativeMessagingHosts = with pkgs; [
      firefoxpwa
      kdePackages.plasma-browser-integration
    ];
  };

  home.pointerCursor = {
    package = pkgs.kdePackages.breeze;
    gtk.enable = true;
    x11.enable = true;
    
    name = "breeze_cursors";
    size = 24;
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      nil
      llmvPackages_18.clang-tools
      python312Packages.python-lsp-server
      python312Packages.python-lsp-ruff
    ];
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

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
