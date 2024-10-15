{pkgs, ...}: {
  imports = [
    ./hyprpaper.nix
    ./waybar.nix
    ./hyprpolkitagent.nix
  ];
}
