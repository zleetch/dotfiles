.ONESHELL:
.SHELL := /usr/bin/bash
.PHONY: zsh starship antigen lazyvim asdf asdfPlugin sync docker

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

depedencies:
	mkdir -p ~/.config
	sudo apt update -y
	sudo apt install -y git curl

depZsh: depedencies
	sudo apt install -y zsh lf

depStarship: depedencies
	sudo apt install -y build-essential software-properties-common cmake

depDocker: depedencies
	sudo apt install -y apt-transport-https ca-certificates gnupg-agent software-properties-common

depLazyvim: depedencies
	sudo apt install -y neovim

zsh: depZsh ## Install zsh
	curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

starship: depStarship ## Install starship and nerdfont
	curl https://sh.rustup.rs -sSf | sh
	. "$(HOME)/.cargo/env"
	cargo install starship --locked
	curl -sS https://webi.sh/nerdfont | sh
	. ~/.config/envman/PATH.env
	webi lsd
	lsd -lahF

antigen: depedencies ## Install Antigen
	curl -L git.io/antigen > ~/.config/.antigen.zsh
	mkdir -p ~/.fzf/shell
	touch ~/.fzf/fzf.zsh ~/.fzf/shell/key-bindings.zsh

lazyvim: depLazyvim ## Install Lazyvim
	git clone https://github.com/LazyVim/starter ~/.config/nvim
	rm -rf ~/.config/nvim.git

asdf: depedencies ## Install asdf
	git clone https://github.com/asdf-vm/asdf.git
	cd asdf
	asdfLatest=$$(git describe --tags --abbrev=0)
	cd ..
	rm -rf asdf
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $$asdfLatest
	. "$(HOME)/.asdf/asdf.sh"
	
asdfPlugin: ## Install asdf plugin
	while IFS= read -r package; do
		asdf plugin add $$package
		packageVersion=$$(asdf list all $$package | tail -n 1)
		asdf install $$package $$packageVersion
		asdf global $$package $$packageVersion
	done <asdf-list.txt

docker: depDocker ## Install docker
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $$(lsb_release -cs) stable"
	sudo apt update
	sudo apt install -y docker-ce docker-ce-cli containerd.io

sync: ## Sync config file
	cp starship.toml ~/.config/starship.toml
	cp .zshrc ~/.zshrc
	cp .tmux.conf ~/.tmux.conf
	cp lazyvim.json ~/.config/nvim/lazyvim.json
	chsh -s $$(which zsh)
