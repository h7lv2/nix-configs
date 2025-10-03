{ config, pkgs, ... }:

{
  imports = [
    ./system-software.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
    inherit (prev.lixPackageSets.stable)
      nixpkgs-review
      nix-eval-jobs
      nix-fast-build
      colmena;
    })
  ];


  # Nix settings
  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
  
  nixpkgs.config.allowUnfree = true;

  # Use a different kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 0;
    # popos settings used here https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };
  
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Networking settings
  time.timeZone = "Europe/Moscow";
  networking = {
    networkmanager = {
      enable = true;
      settings = {
        connectivity = {
          uri = "http://connectivity-check.ubuntu.com";
        };
      };
    };
    firewall.allowedTCPPorts = [ 4242 9300 22000 47984 47989 47990 48010 53317 ];
    firewall.allowedUDPPorts = [ 4242 9300 22000 47998 47999 48000 48010 53317 ];
  };
  networking.proxy.default = "socks5://localhost:2080";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  # Hardware settings
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
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
  users.users = {
    halva = {
      isNormalUser = true;
      extraGroups = [ "adbusers" "lp" "scanner" "networkmanager" "wheel" "podman" ];
    };
    university-testuser = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
  
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      extraPackages = with pkgs; [
        podman-compose
      ];
    };
    vmware = {
      host.enable = true;
      host.extraConfig = ''
        # Allow unsupported device's OpenGL and Vulkan acceleration for guest vGPU
        mks.gl.allowUnsupportedDrivers = "TRUE"
        mks.vk.allowUnsupportedDevices = "TRUE"
      '';
    };
    virtualbox = {
      host.enable = true;
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
        
    openssh.enable = true;
    udev.packages = [ pkgs.sane-airscan ];
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
}
