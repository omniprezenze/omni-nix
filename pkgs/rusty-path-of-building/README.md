If you update the version, you MUST update the hashes (hash and cargoHash).

Change version in 
pkgs/rusty-path-of-building/default.nix
.
Set hash = ""; and cargoHash = "";.
Run nix build .#nixosConfigurations.omnipc.pkgs.rusty-path-of-building.
Nix will error with "got: sha256-...". Copy that hash into hash.
Run the build again. Nix will error with "got: sha256-..." for the cargo hash. Copy that into cargoHash.
Run the build again to confirm it works.