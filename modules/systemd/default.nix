{pkgs, ...}: {
  imports = [
    ./hyprpolkitagent.nix
    ./hyprland-session-target.nix
  ];
}
