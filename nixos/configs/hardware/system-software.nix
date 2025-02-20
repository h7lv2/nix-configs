{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Development
    vscode
    android-studio
    clinfo
    direnv
    wget
    ghostty
    curl
    jujutsu
    git
    vim
    distrobox
    virt-manager
    virt-viewer
    qemu_full

    # Identity management
    bitwarden-desktop
    keepassxc

    # Browsers and messaging    
    whatsie
    telegram-desktop
    chromium
    signal-desktop
    google-chrome
    discord
    element-desktop
    firefox
    firefoxpwa

    # Media
    obs-studio
    pinta
    haruna
    moonlight-qt
    krita

    # Network
    qbittorrent
    localsend
    nekoray
    zerotierone

    # Compatibility
    bottles
    dosbox-staging

    # Office
    thunderbird
    syncthingtray
    simple-scan
    obsidian
    libreoffice-qt6-fresh
    hunspellDicts.ru_RU
    kdePackages.merkuro

    # Misc
    yt-dlp
    wayland-utils
    vulkan-tools
    wl-clipboard
    exfatprogs
    glxinfo
    htop
    libadwaita
    adwaita-fonts
    adwaita-icon-theme
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
