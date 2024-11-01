{
  description = "omni NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, chaotic, aagl, ... }@inputs: {
    nixosConfigurations = {
      omnipc = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        
        modules = [
          ./configs/base.nix
          # chaotic.nixosModules.default
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

