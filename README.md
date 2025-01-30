nixos-rebuild switch --flake
nix profile history --profile /nix/var/nix/profiles/system
nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 14d.


$ nix-env --list-generations --profile /nix/var/nix/profiles/system
# pick a couple or one to remove
$ nix-env --delete-generations --profile /nix/var/nix/profiles/system 163 164
# or anything older than 5 days
$ nix-env --delete-generations --profile /nix/var/nix/profiles/system 5d
