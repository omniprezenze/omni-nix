#! /run/current-system/sw/bin/bash

for file in *; do
  ln -s "$PWD/dotfiles/$file" "$HOME/.config/$file"
done
