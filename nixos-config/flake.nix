{
    description = "NixOS configurations";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs, ... }:
    let
        lib = nixpkgs.lib;
    in {
    omnipc = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./nix-config/configuration.nix ]
    };
    };

}