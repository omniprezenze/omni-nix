{
  description = "omni NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, aagl, ... }@inputs: {
    nixosConfigurations = {
      omnipc = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        
        modules = [
          ./configs/base.nix
          ./configs/desktop.nix
          ./configs/hardware-configuration.nix
          ./configs/amd-gpu.nix
          ./configs/sound.nix
          ./configs/bluetooth.nix
          ./configs/apps.nix
          ./configs/libvirt.nix
          ./configs/steam.nix
          ./configs/aagl.nix
          ./packages/scripts/screenshot.nix
        ];
      };
    };
  };
}
