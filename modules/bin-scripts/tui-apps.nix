{ pkgs, ... }:
let
  impala-tui = pkgs.writeShellScriptBin "impala-tui" ''
    set -eu

    ghostty --title=impala-tui -e impala

    exit 0
  '';

  calcure-tui = pkgs.writeShellScriptBin "calcure-tui" ''
    set -eu

    ghostty --title=calcure-tui -e calcure
    
    exit 0
  '';

  amdgpu-tui = pkgs.writeShellScriptBin "amdgpu-tui" ''
    set -eu

    ghostty --title=amdgpu_top-tui -e amdgpu_top --dark
    
    exit 0
  '';

  btop-tui = pkgs.writeShellScriptBin "btop-tui" ''
    set -eu

    ghostty --title=btop-tui -e btop
    
    exit 0
  '';

in {
  environment.systemPackages = [ impala-tui calcure-tui amdgpu-tui btop-tui ];
}