{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      # bottles-unwrapped = prev.bottles-unwrapped.overrideAttrs (old: {
      #   version = "51.21";
      #   src = pkgs.fetchFromGitHub {
      #     owner  = "bottlesdevs";
      #     repo   = "Bottles";
      #     rev    = "51.21";
      #     sha256 = "19nl1qfxv4iv3hj3rdvwq46i9x2kpw0fix6y6pps8dpv38nvci5d"; 
      #   };
      # });
     bottles = prev.bottles.override {
       removeWarningPopup = true;
     };
    })
  ];
}

