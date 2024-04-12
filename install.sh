#!/usr/bin/env bash

rm -rf ~/.config/nvim &&
	mkdir -p ~/.config/nvim &&
	stow nvim -t ~/.config/nvim
