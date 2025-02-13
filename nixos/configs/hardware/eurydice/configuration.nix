{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../common.nix
      ./hardware-configuration.nix
    ];

  boot.blacklistedKernelModules = [ "nouveau" ];

  # services.xserver.videoDrivers = [ "nvidia" ];

  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = true;
  #   powerManagement.finegrained = false;
  #   open = false;
  #   nvidiaSettings = true;

  #   package = config.boot.kernelPackages.nvidiaPackages.beta;
  #   prime = {
  #     intelBusId = "PCI:0:2:0";
  #     nvidiaBusId = "PCI:4:0:0";
  #     offload = {
  #       enable = true;
  #       enableOffloadCmd = true;
  #     };
  #   };
  # };

  # Use the systemd-boot EFI boot loader.
  boot = { 
    loader.systemd-boot.enable = true;
    loader.systemd-boot.consoleMode = "max";
    loader.efi.canTouchEfiVariables = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };

  # Enable waydroid
  # virtualisation.waydroid.enable = true;
  # systemd.services.waydroid-container.wantedBy = lib.mkForce [];

  networking.hostName = "eurydice";

  system.stateVersion = "24.11";
}

