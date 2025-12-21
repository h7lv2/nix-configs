{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../common.nix
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = { 
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader.efi.canTouchEfiVariables = true;
  };

  hardware.graphics = {
    enable = true;
  };

  # Enable waydroid
  # virtualisation.waydroid.enable = true;
  # systemd.services.waydroid-container.wantedBy = lib.mkForce [];
  virtualisation.virtualbox = {
    host.enableKvm = true;
    host.addNetworkInterface = false;
  };

  networking = {
    hostName = "twinkbook";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 4242 9300 22000 47984 47989 47990 48010 53317 ];
      allowedTCPPortRanges = [
        { from = 6695; to = 6699; } # warframe
        { from = 6881; to = 6889; } # bittorrent
      ];
      allowedUDPPorts = [ 4242
        4950 4955 # warframe
        9300
        22000
        47998 47999 48000 48010 53317 # sunshine
      ];
    };
  };
  
  system.stateVersion = "25.05";
}

