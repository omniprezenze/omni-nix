{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      rusty-path-of-building = prev.callPackage ../pkgs/rusty-path-of-building { };
      vesktop = prev.callPackage ../pkgs/vesktop { vesktop = prev.vesktop; };
    })
  ];
}
