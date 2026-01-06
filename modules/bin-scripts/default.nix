{pkgs, ...}: {
  imports = [
    ./tui-apps.nix
    ./mute_focus.nix
    ./start-hyprland-custom.nix
    ./screenshotter.nix
  ];
}
