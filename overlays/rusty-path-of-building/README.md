Both hosts use this local package instead of the nixpkgs package.

From the repository root on a NixOS machine, update to a specific upstream release:

```sh
nix run github:Mic92/nix-update -- --flake --version=0.3.2 --override-filename overlays/rusty-path-of-building/default.nix rusty-path-of-building
```

Replace `0.3.2` with the release version, without the `v` prefix. The command updates the version, source hash, and Cargo dependency hash in `default.nix`. Alternatively, edit the version in that file yourself and run the same command with `--version=skip` to refresh both hashes.

Build the package before switching generations:

```sh
nix build .#rusty-path-of-building
sudo nixos-rebuild build --flake .#omnipc
```

Use `.#omnilaptop` for the laptop. The updater does not build the package or activate a generation; upstream changes may also require changes to the package expression.