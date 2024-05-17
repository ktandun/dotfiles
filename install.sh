#!/usr/bin/env bash

rm -rf ~/.config/nvim && \
	mkdir -p ~/.config/nvim && \
	stow nvim -t ~/.config/nvim

rm -rf ~/.config/alacritty && \
	mkdir -p ~/.config/alacritty && \
	stow alacritty -t ~/.config/alacritty

brew install font-jetbrains-mono-nerd-font
brew install cmake
brew install luarocks

brew tap isen-ng/dotnet-sdk-versions && \
	brew install --cask dotnet-sdk8-0-200
