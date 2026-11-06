{ pkgs, ... }:
let
  impala-tui = pkgs.writeShellScriptBin "impala-tui" ''
    set -eu

    exec ${pkgs.ghostty}/bin/ghostty --title=impala-tui -e ${pkgs.impala}/bin/impala

  '';

  btop-tui = pkgs.writeShellScriptBin "btop-tui" ''
    set -eu

    exec ${pkgs.ghostty}/bin/ghostty --title=btop-tui -e ${pkgs.btop}/bin/btop
  '';

in {
  environment.systemPackages = [ impala-tui btop-tui ];
}