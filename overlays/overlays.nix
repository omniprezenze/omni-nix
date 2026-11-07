{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      rusty-path-of-building = prev.callPackage ./rusty-path-of-building { };
    })
  ];
}
