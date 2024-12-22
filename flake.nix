{
  description = "omni NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
          ./packages/scripts/screenshot.nix
          ./configs/aagl.nix
        ];
      };
    };
  };
}
