{
  description = "omni NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    tuigreet.url = "github:NotAShelf/tuigreet"; # https://github.com/NotAShelf/tuigreet
  };

  outputs = { nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      omnilaptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./hosts/omnilaptop
          { nixpkgs.overlays = [ (final: prev: {
              tuigreet = inputs.tuigreet.packages.${prev.hostPlatform.system}.tuigreet;
            }) ]; }
          #nixos-hardware.nixosModules.lenovo-legion-15ach6h
        ];
      };
      omnipc = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./hosts/omnipc
          ./modules/systemd/default.nix
          ./modules/bin-scripts/default.nix
          ./modules/aagl.nix
          {
            nixpkgs.overlays = [
              (final: prev: {
                tuigreet = inputs.tuigreet.packages.${prev.stdenv.hostPlatform.system}.tuigreet;
              })
              (final: _prev: {
                pnpm_10_29_2 = final.pnpm_10;
              })
            ];
          }        
        ];
      };
    };
  };
}
