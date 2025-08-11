{
  description = "omni NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs = { nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      omnilaptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./hosts/omnilaptop
          #nixos-hardware.nixosModules.lenovo-legion-15ach6h
        ];
      };
      omnipc = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./hosts/omnipc
          ./modules/services/default.nix
          ./modules/bin-scripts/default.nix
          ./modules/aagl.nix
        ];
      };
    };
  };
}
