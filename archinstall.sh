#!/usr/bin/env sh

pacman -S --noconfirm chezmoi
curl -o ~/.config/chezmoi/chezmoi.toml https://raw.githubusercontent.com/Lillenne/dotfiles/refs/heads/main/chezmoi.toml.example
vim ~/.config/chezmoi/chezmoi.toml
chezmoi init https://github.com/Lillenne/dotfiles.git
chezmoi apply
