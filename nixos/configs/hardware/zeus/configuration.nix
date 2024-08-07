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
  
  hardware.graphics = {
    enable = true;
  };
  
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
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
  boot.kernelParams = [
    "nvidia.NVreg_EnableGpuFirmware=0"
  ];


  nixpkgs.config.packageOverrides = pkgs: {
    sunshine = pkgs.sunshine.override {
      cudaSupport = true;
    };
  };

  virtualisation.virtualbox.host.enable = true;

  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "eli";
  };

  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    autoStart = true;
  };

  networking.hostName = "zeus"; # Define your hostname.
  system.stateVersion = "24.05"; # Did you read the comment?

}

