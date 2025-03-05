{
  description = "Flake freezer for NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = { 
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dnclient = {
      url = "github:h7lv2/custom-flakes?dir=dnclient";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  outputs = { self, nixpkgs, lix-module, home-manager, chaotic, dnclient,  ... }: {
    nixosConfigurations.eurydice = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        lix-module.nixosModules.default
        ./configs/hardware/eurydice/configuration.nix
        chaotic.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.eli = import ./configs/home/eurydice.nix;
        }
        dnclient.nixosModules.default
      ];
    };
    nixosConfigurations.zeus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        lix-module.nixosModules.default
        ./configs/hardware/zeus/configuration.nix
        chaotic.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.eli = import ./configs/home/zeus.nix;
        }
      ];
    };

  };
}
