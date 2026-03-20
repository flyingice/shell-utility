#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# OCI Oracle Linux 9.7 (aarch64) - VM setup script
# ============================================================

echo "=== Installing git (required to bootstrap Homebrew) ==="
sudo dnf install -y git

echo "=== Installing Homebrew ==="
# NONINTERACTIVE=1 skips confirmation prompts
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Make brew available for the rest of this script; also add this line to ~/.bashrc for persistence
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "=== Installing tools via Homebrew ==="
brew install bat fd fzf lazygit neovim ripgrep yazi zoxide

echo "=== Cloning dotfiles ==="
git clone --bare --filter=blob:none https://github.com/flyingice/.dotfiles.git ~/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME sparse-checkout set --no-cone '/.zshenv' '/.config/'
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout

echo "=== Installing zsh and setting as default shell ==="
brew install zsh
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s "$(command -v zsh)" "$(whoami)"

echo "=== Installing Oh My Zsh ==="
ZSH=~/.config/oh-my-zsh
ZSH=$ZSH sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

echo "=== Installing Oh My Zsh plugins ==="
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH}/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH}/custom/plugins/zsh-syntax-highlighting

echo "=== Done ==="
