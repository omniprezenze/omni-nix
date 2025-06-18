{pkgs, ...}: {
  imports = [
    ./poe-hotkeys.nix
    ./screenshotter.nix
    ./tui-apps.nix
  ];
}
