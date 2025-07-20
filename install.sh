#!/bin/bash

# Dotfiles Installation Script
# Works on macOS and WSL/Linux
# Run with: ./install.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Detect platform
detect_platform() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        PLATFORM="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]] || [[ -n "$WSL_DISTRO_NAME" ]]; then
        PLATFORM="linux"
    else
        log_error "Unsupported platform: $OSTYPE"
        exit 1
    fi
    log_info "Detected platform: $PLATFORM"
}

# Install package managers and basic tools
install_package_manager() {
    if [[ "$PLATFORM" == "macos" ]]; then
        if ! command -v brew &> /dev/null; then
            log_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            log_success "Homebrew already installed"
        fi
    elif [[ "$PLATFORM" == "linux" ]]; then
        log_info "Updating apt package list..."
        sudo apt update
        log_info "Installing essential packages..."
        sudo apt install -y curl git zsh
    fi
}

# Install nvm (Node Version Manager)
install_nvm() {
    if [[ ! -d "$HOME/.nvm" ]]; then
        log_info "Installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        
        # Source nvm immediately
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        
        log_info "Installing latest LTS Node.js..."
        nvm install --lts
        nvm use --lts
        nvm alias default lts/*
        log_success "Node.js $(node --version) installed"
    else
        log_success "nvm already installed"
    fi
}

# Install zsh plugins
install_zsh_plugins() {
    # Create plugins directory
    mkdir -p ~/.zsh/plugins
    
    # Install zsh-syntax-highlighting
    if [[ ! -d ~/.zsh/plugins/zsh-syntax-highlighting ]]; then
        log_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting
    else
        log_success "zsh-syntax-highlighting already installed"
    fi
    
    # Install zsh-autosuggestions (fish-like autosuggestions)
    if [[ ! -d ~/.zsh/plugins/zsh-autosuggestions ]]; then
        log_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
    else
        log_success "zsh-autosuggestions already installed"
    fi
}

# Create symlinks for dotfiles
create_symlinks() {
    local dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    log_info "Creating symlinks..."
    
    # Backup existing files
    for file in ~/.zshrc ~/.gitconfig ~/.vimrc; do
        if [[ -f "$file" ]] && [[ ! -L "$file" ]]; then
            log_warning "Backing up existing $file to ${file}.backup"
            mv "$file" "${file}.backup"
        fi
    done
    
    # Create symlinks
    ln -sf "$dotfiles_dir/zsh/zshrc" ~/.zshrc
    ln -sf "$dotfiles_dir/git/gitconfig" ~/.gitconfig
    ln -sf "$dotfiles_dir/vim/vimrc" ~/.vimrc    
    log_success "Symlinks created"
}

# Set zsh as default shell
set_default_shell() {
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        log_info "Setting zsh as default shell..."
        chsh -s $(which zsh)
        log_success "Default shell set to zsh (will take effect on next login)"
    else
        log_success "zsh is already the default shell"
    fi
}

# Main installation function
main() {
    log_info "Starting dotfiles installation..."
    
    detect_platform
    install_package_manager
    install_nvm
    install_zsh_plugins
    create_symlinks
    set_default_shell
    
    log_success "Dotfiles installation complete!"
    log_info "Please restart your terminal or run 'source ~/.zshrc' to load the new configuration"
    log_info "You may need to log out and back in for the shell change to take effect"
}

# Run main function
main "$@"
