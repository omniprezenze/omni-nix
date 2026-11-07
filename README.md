### Nixos config. Features:
- uwsm sway, uwsm hyprland (profiling with wrapper)
- gaming stuff
- some bin scripts
- dotfiles

### hosts
- omnipc: amd desktop
- omnilaptop: intel + nvidia laptop

# How to for myself
### initial installation
`initial.sh /dev/disk` erases the selected disk after confirmation. It expects a filesystem labelled `home` on a separate disk to already exist.

### DMS and Hyprland dotfiles
The NixOS configuration installs DMS and Hyprland but does not deploy their user dotfiles. Run `bash ./link-dotfiles.sh` to link non-empty dotfile directories into `~/.config`. The script skips existing paths without replacing them and reports conflicts with a nonzero exit status. Back up or move any conflicting settings before running it again. If the legacy `~/.config/DankMaterialShell` path exists and `~/.config/dms` does not, the script skips DMS so you can inspect the existing settings before migrating them.

After the repository directory rename, an existing `~/.config/dms` symlink pointing to `dotfiles/DankMaterialShell` will be dangling. Check it with `readlink ~/.config/dms`, then remove that old symlink and rerun the script.

Keep the DMS settings and `hypr/dms` fragments writable so DMS can update them. The checked-in custom theme path assumes the default `~/.config/dms` location. After deployment, log out and back in, then check `dms doctor -v`, `hyprctl configerrors`, and `systemctl --user status dms.service graphical-session.target hyprland-session.target`. Test manual locking, idle locking, and suspend with another TTY available.

Deploy `dotfiles/wlogout` to `~/.config/wlogout` for the power menu bound to Super+Backspace. DMS manages the wallpaper, idle locking, display power, and locking before suspend. On AC and battery, it locks after 5 minutes idle and turns displays off after 1 minute locked; idle suspend is disabled. The lock shortcut and wlogout also invoke the DMS lock screen.

Super+Shift+U toggles the focused monitor's position, or restores displaced monitors. It requires `wlr-randr`, installed by the desktop module after rebuilding NixOS. This is not a screen lock. `start-hyprland-custom` remains available as a compatibility wrapper around `start-hyprland`; host selection now happens in the Lua configuration.

### Tuigreet
On omnipc, NixOS installs `dotfiles/tuigreet/config.toml` to `/etc/tuigreet/config.toml` because tuigreet runs as `greeter`, not as the logged-in user. Rebuild after changing it. The output settings choose the display used to calculate terminal size; they do not turn other monitors off.

### clean ups
nixos-rebuild switch --flake
nix profile history --profile /nix/var/nix/profiles/system
nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 14d.


$ nix-env --list-generations --profile /nix/var/nix/profiles/system
# pick a couple or one to remove
$ nix-env --delete-generations --profile /nix/var/nix/profiles/system 163 164
# or anything older than 5 days
$ nix-env --delete-generations --profile /nix/var/nix/profiles/system 5d
