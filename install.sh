#!/usr/bin/env bash

rm -rf ~/.config/nvim &&
	mkdir -p ~/.config/nvim &&
	stow nvim -t ~/.config/nvim

rm -rf ~/.config/alacritty &&
	mkdir -p ~/.config/alacritty &&
	stow alacritty -t ~/.config/alacritty

 brew tap homebrew/cask-fonts && brew install --cask font-jetbrains-mono-nerd-font
