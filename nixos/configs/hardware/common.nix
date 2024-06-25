{ config, pkgs, ... }:

{
  imports = [
    ./secrets.nix
  ];

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "14d";
    randomizedDelaySec = "6h";
    persistent = true;
    options = "--delete-older-than 7d";
  };
  
  # Use a different kernel
  boot.kernelPackages = pkgs.linuxPackages_cachyos;


  # Pretty boot!
  boot.plymouth.enable = true;
  boot.plymouth.theme = "bgrt";
  boot.initrd.systemd.enable = true;
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" "udev.log_level=0" ];
  console.earlySetup = true;  

  # Networking settings
  time.timeZone = "Europe/Moscow";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 22000 47984 47989 47990 48010 53317 ];
  networking.firewall.allowedUDPPorts = [ 22000 47998 47999 48000 48010 53317 ];
  
  # Hardware settings
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.firmware = [ pkgs.rtl8761b-firmware ];
  hardware.xpadneo.enable = true;

  # User settings
  users.users.eli = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd"  ];
  };

  # Virtualisation settings
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # Services and apps
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;
  
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
   
  services.flatpak.enable = true;
  
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
