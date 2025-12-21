{
  description = "Flake freezer for NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-cachyos-kernel,
      lanzaboote,
      niri,
      ...
    }:
    let
      kernelOverlayModule =
        { pkgs, ... }:
        {
          nixpkgs.overlays = [
            nix-cachyos-kernel.overlays.pinned
          ];
          # Select one of the available kernel variants:
          boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
        };
    in
    {
      nixosConfigurations.twinkbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configs/hardware/twinkbook/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.halva = import ./configs/home/twinkbook.nix;
          }
          lanzaboote.nixosModules.lanzaboote
          niri.nixosModules.niri
          kernelOverlayModule # Add this
        ];
      };

      nixosConfigurations.twinkstation = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configs/hardware/twinkstation/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.halva = import ./configs/home/common.nix;
          }
          niri.nixosModules.niri
          kernelOverlayModule
        ];
      };
    };
}
