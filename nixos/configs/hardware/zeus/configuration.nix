# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../common.nix
      ./hardware-configuration.nix
    ];
  
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;

    # powerManagement.enable = true;
    # powerManagement.finegrained = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "zeus"; # Define your hostname.
  system.stateVersion = "24.05"; # Did you read the comment?

}

