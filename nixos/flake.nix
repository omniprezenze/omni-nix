{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, aagl, ... }:
  let
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      omnipc = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configs/base.nix
          # star rail launcher
          aagl.nixosModules.default
          {
            nix.settings = aagl.nixConfig;
            programs.anime-games-launcher.enable = true;
          }
        ];
      };
    };
  };
}

