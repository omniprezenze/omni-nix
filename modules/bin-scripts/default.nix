{pkgs, ...}: {
  imports = [
    ./poe-hotkeys.nix
    ./screenshotter.nix
    ./tui-apps.nix
    ./mute_focus.nix
  ];
}
