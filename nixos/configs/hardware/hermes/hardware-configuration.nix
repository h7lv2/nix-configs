# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/3ab94ea4-5b80-493e-a686-dcd40256dd48";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd:1" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/070c8951-af82-4a57-bc44-a0b85f8034ef";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/3ab94ea4-5b80-493e-a686-dcd40256dd48";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd:1" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/3ab94ea4-5b80-493e-a686-dcd40256dd48";
      fsType = "btrfs";
      options = [ "subvol=@nix" "noatime" ];
    };

  # fileSystems."/var/log" =
  #   { device = "/dev/disk/by-uuid/3ab94ea4-5b80-493e-a686-dcd40256dd48";
  #     fsType = "btrfs";
  #     options = [ "subvol=@var@log" "compress:zstd" ];
  #   };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7D83-6D26";
      fsType = "vfat";
      options = [ "uid=0" "gid=0" "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/3ab94ea4-5b80-493e-a686-dcd40256dd48";
      fsType = "btrfs";
      options = [ "subvol=@swap" ];
    };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s20u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
