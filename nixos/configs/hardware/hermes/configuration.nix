{ config, pkgs, ... }:

{
  imports =
    [
      ../common.nix
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;

  # Pretty boot!
  boot.plymouth.enable = true;
  boot.plymouth.theme = "bgrt";
  boot.initrd.systemd.enable = true;
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" "udev.log_level=0" ];
  console.earlySetup = true;  

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };

  networking.hostName = "hermes";

  system.stateVersion = "24.05";
}

