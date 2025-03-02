{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Browsers and messaging    
    chromium
    discord
    element-desktop
    firefox
    firefoxpwa
    google-chrome
    signal-desktop
    telegram-desktop
    whatsie

    # Compatibility
    bottles
    dosbox-staging

    # Development
    android-studio
    clinfo
    curl
    direnv
    distrobox
    ghostty
    git
    jujutsu
    qemu_full
    vim
    virt-manager
    virt-viewer
    vscode
    wget
    zellij

    # Identity management
    bitwarden-desktop
    keepassxc

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
    nebula
    nekoray
    mosh
    qbittorrent
    zerotierone
    
    # Office
    hunspellDicts.ru_RU
    kdePackages.merkuro
    libreoffice-qt6-fresh
    obsidian
    simple-scan
    syncthingtray
    thunderbird
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
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      extraPackages = with pkgs; [
        mangohud
      ];
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
