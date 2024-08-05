#!/usr/bin/env bash

rm -rf ~/.config/nvim && \
	mkdir -p ~/.config/nvim && \
	stow nvim -t ~/.config/nvim

rm -rf ~/.config/alacritty && \
	mkdir -p ~/.config/alacritty && \
	stow alacritty -t ~/.config/alacritty

rm -rf ~/.tmux.conf && \
	stow tmux -t ~/

brew install font-jetbrains-mono-nerd-font
brew install cmake
brew install luarocks

brew install tmux

brew tap isen-ng/dotnet-sdk-versions && \
	brew install --cask dotnet-sdk8-0-200

# install plugin to let tsserver understand vue files
mkdir -p "~/.local/share/nvim/mason/packages" && \
	cd "~/.local/share/nvim/mason/packages" && \
	npm install --prefix vue-typescript-plugin @vue/typescript-plugin

# install plugin manager for tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
