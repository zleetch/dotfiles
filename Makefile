BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
RESET=$(shell tput sgr0)

ROOTPATH=$(shell pwd)

.ONESHELL:
.SHELL := /usr/bin/bash
.PHONY: zsh starship antigen lazyvim asdf

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

depedencies:
	mkdir -p ~/.config
	sudo apt update -y
	sudo apt install -y git curl

depZsh: depedencies
	sudo apt install -y zsh

depAsdf: depedencies
	git clone https://github.com/asdf-vm/asdf.git
	cd asdf
	asdfLatestVersion=`git describe --tags --abbrev=0`
	cd ..
	rm -rf asdf

depStarship: depedencies
	sudo apt install -y build-essential software-properties-common cmake

zsh: depZsh ## Install zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

starship: depStarship ## Install starship and nerdfont
	curl https://sh.rustup.rs -sSf | sh
	. "$HOME/.cargo/env"
	cargo install starship --locked
	curl -sS https://webi.sh/nerfont | sh
	. ~/.config/envman/PATH.env
	webi lsd
	lsd -lahF

antigen: depedencies ## Install Antigen
	curl -L git.io/antigen > #HOME/.config/.antigen.zsh
	touch ~/.fzf.zsh

lazyvim: depedencies ## Install Lazyvim
	git clone https://github.com/LazyVim/starter ~/.config/nvim
	rm -rf ~/.config/nvim.git

asdf: depAsdf ## Install asdf
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $(asdfLatestVersion)
	while read package; do
		packageVersion=`asdf list all $(package) | tail -n 1`
		asdf install $(package) $(packageVersion)
		asdf global $(package) $(packageVersion)
	done <asdf-list.txt

sync: ## Sync config file
	cp starship.toml ~/.config/starship.toml
	cp .zshrc ~/.zshrc
	zsh

