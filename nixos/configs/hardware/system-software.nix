{ config, pkgs, lib, ... }:
{ 
  environment.systemPackages = with pkgs; [
    # Browsers and messaging    
    ayugram-desktop
    discord
    element-desktop
    firefox
    firefoxpwa
    google-chrome
    signal-desktop
    ungoogled-chromium
    yandex-disk

    # Development
    clinfo
    curl
    direnv
    distrobox
    ghostty
    git
    jujutsu
    vim
    vscode
    wget
    zellij

    # Identity management
    bitwarden-desktop
    ente-auth
    keepassxc
    sbctl

    # Media
    haruna
    krita
    moonlight-qt
    obs-studio
    pinta

    # Misc
    adwaita-fonts
    adwaita-icon-theme
    exfatprogs
    glxinfo
    htop
    libadwaita
    vulkan-tools
    wayland-utils
    wl-clipboard
    yt-dlp

    # Network
    localsend
    mosh
    nekoray
    packet
    qbittorrent
    
    # Office
    anytype
    hunspellDicts.ru_RU
    kdePackages.merkuro
    libreoffice-qt6-fresh
    obsidian
    simple-scan
    syncthingtray
    thunderbird
    tinymist
    typst
    zathura
  ];  

  programs.firefox.package = pkgs.firefox.override {
    nativeMessagingHosts = with pkgs; [
      firefoxpwa
      kdePackages.plasma-browser-integration
    ];
  };

  programs = {
    adb.enable = true;
    dconf.enable = true; # because gtk is just quirky and special
    niri = {
      enable = true;
    };
    steam = {
      package = pkgs.steam.override {
        extraBwrapArgs = [ "--unsetenv TZ" ];
      };
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      extraPackages = with pkgs; [
        kdePackages.breeze
        mangohud
      ];
      protontricks.enable = true;
      remotePlay.openFirewall = true;
    };
    partition-manager.enable = true;
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
    ];
  };
}
