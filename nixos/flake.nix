{
  description = "Flake freezer for NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = { 
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, chaotic, ... }: {
    nixosConfigurations.hermes = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        configs/hardware/hermes/configuration.nix
        chaotic.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.eli = import ./configs/home/hermes.nix;
        }
      ];
    };
    nixosConfigurations.zeus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        configs/hardware/zeus/configuration.nix
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
