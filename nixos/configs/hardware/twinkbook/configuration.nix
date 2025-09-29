{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../common.nix
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = { 
    loader.systemd-boot.enable = true;
    loader.systemd-boot.consoleMode = "max";
    loader.efi.canTouchEfiVariables = true;
  };

  hardware.graphics = {
    enable = true;
  };

  # Enable waydroid
  # virtualisation.waydroid.enable = true;
  # systemd.services.waydroid-container.wantedBy = lib.mkForce [];

  networking.hostName = "twinkbook";

  system.stateVersion = "25.05";
}

