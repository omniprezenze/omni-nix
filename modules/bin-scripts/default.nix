{pkgs, ...}: {
  imports = [
    ./screenshotter.nix
    ./tui-apps.nix
    ./mute_focus.nix
  ];
}
