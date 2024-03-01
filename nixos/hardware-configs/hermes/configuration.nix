# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports =
    [ # Auto-generated, don't touch.
      ./hardware-configuration.nix

      # Unfucks go here
      ../../botches/unfuck-intel-vaapi.nix
      ../../botches/unfuck-flatpak.nix
      ../common.nix
    ];

  # Use the latest kernel 
  # TODO: figure out a way to change that on the other machine 
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "quiet" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-c79841bf-50e5-4c79-aa0e-dcedbc8e3e6b".device = "/dev/disk/by-uuid/c79841bf-50e5-4c79-aa0e-dcedbc8e3e6b";
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";

  networking.hostName = "hermes"; # Define your hostname.
}
