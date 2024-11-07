# Create config directory
mkdir -p ~/.config

# Install cargo
curl https://sh.rustup.rs -sSf | sh

# Installing depedencies
apt install neovim git curl build-essential software-properties-common cmake

# Install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install starship
cargo install starship --locked

# Install starship preset
cp starship.toml ~/.config/starship.toml

# Install nerdfont
curl -sS https://webi.sh/nerdfont | sh
source ~/.config/envman/PATH.env
webi lsd
lsd -lahF

# Install antigen
curl -L git.io/antigen > $HOME/.config/.antigen.zsh

cp .zshrc ~/.zshrc
source ~/.zshrc

# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch `git describe --tags --abbrev=0`

# Install latest package with asdf
while read package; do
  asdf plugin add $package
  packageVersion=`asdf list all $package | tail -n 1`
  asdf install $package $packageVersion
  asdf global $package $packageVersion
done <asdf-list.txt

# Install lazyvim
git clone https://github.com/LazyVim/starter ~/.config/nvim

rm -rf ~/.config/nvim.git
