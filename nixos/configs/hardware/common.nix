{ config, pkgs, ... }:

{
  # Nix settings
  nix.settings = {
    auto-optimise-store = true;
    download-buffer-size = 536870912;
    experimental-features = [ "nix-command" "flakes" ];
  };
  
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "3d";
    randomizedDelaySec = "6h";
    persistent = true;
    options = "--delete-older-than 7d";
  };
  
  # Use a different kernel
  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;

  # Pretty boot!
  boot = {
    plymouth.enable = true;
    plymouth.theme = "bgrt";
    initrd.systemd.enable = true;
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "udev.log_level=0" ];
  };
  console.earlySetup = true;  

  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 0;
  };

  # NV Modprobe tweaks taken from cachyos
  boot.extraModprobeConfig = ''
    options nvidia NVreg_UsePageAttributeTable=1 \
      NVreg_InitializeSystemMemoryAllocations=0 \
      NVreg_DynamicPowerManagement=0x02 \
      NVreg_EnableGpuFirmware=0 \
      NVreg_RegistryDwords=RMIntrLockingMode=1
    options nvidia_drm modeset=1
  '';

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Networking settings
  time.timeZone = "Europe/Moscow";
  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 22000 47984 47989 47990 48010 53317 ];
    firewall.allowedUDPPorts = [ 22000 47998 47999 48000 48010 53317 ];
    hosts = {
      "127.0.0.1" = [ "mwlogin.net" ];
    };
  };
  
  # Hardware settings
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    firmware = [ pkgs.rtl8761b-firmware ];
    sane = {
      enable = true;
      disabledDefaultBackends = [ "escl" ];
      extraBackends = with pkgs; [
        hplip
        hplipWithPlugin
        sane-airscan
      ];
    };
  };
  
  # User settings
  users.users.eli = {
    isNormalUser = true;
    extraGroups = [ "adbusers" "lp" "scanner" "networkmanager" "wheel" "podman" ];
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_full;
        swtpm.enable = true;
      };    
    };
  };
  
  # Services and apps
  services = {
    avahi = { 
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
    
    displayManager = {
      sddm.enable = true;
      sddm.wayland.enable = true;
    };

    desktopManager = {
      plasma6.enable = true;
    };

    resolved.enable = true;

    ipp-usb.enable = true;

    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        gutenprintBin
        hplip
        hplipWithPlugin
      ];
    };

    pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    scx = {
      enable = true;
      scheduler = "scx_lavd";
    };
    
    openssh.enable = true;
    udev.packages = [ pkgs.sane-airscan ];
    zerotierone = {
      enable = true;
      joinNetworks = [ "93afae5963c40e46" ];
      localConf = { 
        settings = { 
          softwareUpdate = "disable";
        };
      };
    };
  };

  # for pipewire to request realtime mode
  security.rtkit.enable = true;
   
  services.flatpak.enable = true;
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };
    aggregatedIcons = pkgs.buildEnv {
      name = "system-icons";
      paths = with pkgs; [
        #libsForQt5.breeze-qt5  # for plasma
        kdePackages.breeze
        # kdePackages.breeze-gtk
        adwaita-fonts
        adwaita-icon-theme
        gnome-themes-extra
      ];
      pathsToLink = [ "/share/icons" ];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = [ "/share/fonts" ];
    };
  in {
    "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
    "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
    ];
  };

  programs = {
    adb.enable = true;
    dconf.enable = true; # because gtk is just quirky and special
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      extraPackages = with pkgs; [
        mangohud
      ];
      remotePlay.openFirewall = true;
    };
    partition-manager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Development
    wget
    curl
    git
    vim
    distrobox
    virt-manager
    virt-viewer
    qemu_full
    nemu

    # Network
    zerotierone

    # Misc
    wl-clipboard
    exfatprogs
    htop
    libadwaita
    adwaita-fonts
    adwaita-icon-theme
  ];  
}
