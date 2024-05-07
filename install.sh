#!/usr/bin/env bash

rm -rf ~/.config/nvim &&
	mkdir -p ~/.config/nvim &&
	stow nvim -t ~/.config/nvim

rm -rf ~/.config/alacritty &&
	mkdir -p ~/.config/alacritty &&
	stow alacritty -t ~/.config/alacritty
