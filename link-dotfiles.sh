#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
config_dir="$HOME/.config"
failed=0

mkdir -p -- "$config_dir"

for source in "$repo_dir"/dotfiles/*; do
    [[ -d "$source" ]] || continue
    [[ -n "$(find "$source" ! -type d -print -quit)" ]] || continue

    name="${source##*/}"
    target="$config_dir/$name"
    if [[ "$name" == "dms" ]]; then
        legacy_target="$config_dir/DankMaterialShell"
        if [[ ! -e "$target" && ! -L "$target" && ( -e "$legacy_target" || -L "$legacy_target" ) ]]; then
            printf 'Skipped %s: legacy DMS path exists: %s\n' "$target" "$legacy_target" >&2
            failed=1
            continue
        fi
    fi

    if [[ -L "$target" && "$target" -ef "$source" ]]; then
        printf 'Already linked: %s\n' "$target"
    elif [[ -e "$target" || -L "$target" ]]; then
        printf 'Skipped existing path: %s\n' "$target" >&2
        failed=1
    elif ln -s "$source" "$target"; then
        printf 'Linked %s -> %s\n' "$target" "$source"
    else
        printf 'Failed to link: %s\n' "$target" >&2
        failed=1
    fi
done

exit "$failed"