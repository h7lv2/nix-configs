{ config, pkgs, ... }:

{
  imports = [
    ./secrets.nix
  ];

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  
  # Use a different kernel
  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  # Networking settings
  time.timeZone = "Europe/Moscow";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 22000 47984 47989 47990 48010 53317 ];
  networking.firewall.allowedUDPPorts = [ 22000 47998 47999 48000 48010 53317 ];
  
  # Hardware settings
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.firmware = [ pkgs.rtl8761b-firmware ];

  # User settings
  users.users.eli = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd"  ];
  };

  # Virtualisation settings
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # Services and apps
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
  services.zerotierone.enable = true;
  
  programs.dconf.enable = true; # because gtk is just quirky and special
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
  ];  
}
