{
  description = "Flake freezer for NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = { 
      url = "github:nix-community/home-manager";
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

  # nixConfig = {
  #   extra-substituters = [
  #     "https://niri.cachix.org"  
  #   ];
  #   extra-trusted-public-keys = [
  #     "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
  #   ];
  # };

  outputs = { self, nixpkgs, home-manager, chaotic, lanzaboote, niri, ... }: {
    nixosConfigurations.twinkbook = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configs/hardware/twinkbook/configuration.nix
        chaotic.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.halva = import ./configs/home/twinkbook.nix;
        }
        lanzaboote.nixosModules.lanzaboote
        niri.nixosModules.niri
      ];
    };
  };
}
