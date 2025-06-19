{pkgs, ...}: {
  imports = [
    ./hyprpaper.nix
    ./waybar.nix
    ./hyprpolkitagent.nix
    ./swayidle.nix
  ];
}
