{
    description = "NixOS configurations";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs, ... }:
    let
        lib = nixpkgs.lib;
    in {
        nixosConfigurations = {
            omnipc = lib.nixosSystem {
                system = "x86_64-linux";
                modules = [ ./configs/base.nix ];
            };
        };
    };
}