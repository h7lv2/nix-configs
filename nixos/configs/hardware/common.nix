{ config, pkgs, ... }:

{
  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;

  # nix.gc = {
  #   automatic = true;
  #   dates = "14d";
  #   randomizedDelaySec = "6h";
  #   persistent = true;
  #   options = "--delete-older-than 7d";
  # };
  
  # Use a different kernel
  # boot.kernelPackages = pkgs.linuxPackages_cachyos;

  # Pretty boot!
  boot.plymouth.enable = true;
  boot.plymouth.theme = "bgrt";
  boot.initrd.systemd.enable = true;
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" "udev.log_level=0" ];
  console.earlySetup = true;  

  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 0;
  };

  # Networking settings
  time.timeZone = "Europe/Moscow";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 22000 47984 47989 47990 48010 53317 ];
  networking.firewall.allowedUDPPorts = [ 22000 47998 47999 48000 48010 53317 ];
  networking.hosts = {
    "127.0.0.1" = [ "mwlogin.net" ];
  };
  
  # Hardware settings
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.firmware = [ pkgs.rtl8761b-firmware ];

  # User settings
  users.users.eli = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "podman" ];
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  
  # Services and apps
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;
  
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
   
  services.flatpak.enable = true;
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };
    aggregatedIcons = pkgs.buildEnv {
      name = "system-icons";
      paths = with pkgs; [
        #libsForQt5.breeze-qt5  # for plasma
        kdePackages.breeze
        kdePackages.breeze-gtk
        # gnome.gnome-themes-extra
      ];
      pathsToLink = [ "/share/icons" ];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = [ "/share/fonts" ];
    };
  in {
    "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
    "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
  };
  services.resolved.enable = true;

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
    ];
  };

  
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };
  # for pipewire to request realtime 
  security.rtkit.enable = true;
  
  services.openssh.enable = true;
  services.printing.enable = true;
  services.zerotierone = {
    enable = true;
    joinNetworks = [ "93afae5963c40e46" ];
    localConf = { 
      settings = { 
        softwareUpdate = "disable";
      };
    };
  };
  
  programs.dconf.enable = true; # because gtk is just quirky and special
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    extraPackages = with pkgs; [
      mangohud
    ];
    remotePlay.openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    # Development
    wget
    curl
    git
    vim
    distrobox
    virt-manager

    # Network
    zerotierone

    # Misc
    wl-clipboard
    htop
  ];  
}
