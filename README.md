# Dotfiles Setup

A minimal, modular shell configuration that works across macOS and WSL/Linux environments.

## Features

- **Cross-platform**: Works on macOS and WSL/Linux
- **Minimal base**: Clean starting point with essential features
- **Modular**: Easy to extend and customize
- **Version controlled**: Full Git integration for syncing across machines
- **Modern zsh setup**: With syntax highlighting and smart completions

### What's Included

- **Better command history**: Shared across sessions, no duplicates
- **Basic aliases**: Common shortcuts (ll, la, gs, gc, etc.)
- **Improved tab completion**: Case-insensitive, colored, menu-style
- **Git-aware prompt**: Shows current branch
- **Syntax highlighting**: Real-time command validation
- **Node.js via nvm**: Version management across environments
- **Platform detection**: Automatic macOS vs Linux configuration

## Quick Start

1. **Clone this repository**:
   ```bash
   git clone https://github.com/colliand/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the installation script**:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Update Git configuration**:
   Edit `git/gitconfig` and update the `[user]` section with your name and email.

4. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

## File Structure

```
~/dotfiles/
├── install.sh           # Main setup script
├── zsh/
│   └── zshrc           # Main zsh configuration
├── git/
│   └── gitconfig       # Git settings
└── README.md           # This file
```

## What the Install Script Does

### On macOS:
- Installs Homebrew (if not present)
- Sets up zsh as default shell
- Installs nvm and latest Node.js LTS
- Installs zsh plugins for syntax highlighting and autosuggestions
- Creates symlinks to configuration files

### On WSL/Linux:
- Updates apt packages
- Installs essential tools (curl, git, zsh)
- Sets up zsh as default shell
- Installs nvm and latest Node.js LTS
- Installs zsh plugins for syntax highlighting and autosuggestions
- Creates symlinks to configuration files

## Key Features Explained

### Command History
- **Shared across sessions**: History from one terminal appears in others
- **No duplicates**: Removes duplicate commands automatically
- **Immediate append**: Commands saved instantly, not on shell exit
- **Smart search**: Use Ctrl+R for reverse search

### Aliases
```bash
# Navigation
ll          # Detailed file listing
la          # Show hidden files
..          # Go up one directory
...         # Go up two directories

# Git shortcuts
gs          # git status
ga          # git add
gc          # git commit
gp          # git push
gl          # git pull

# Safety
rm          # rm -i (confirms deletions)
cp          # cp -i (confirms overwrites)
mv          # mv -i (confirms moves)
```

### Custom Functions
```bash
mkcd <dir>      # Create directory and cd into it
qfind <term>    # Quick file search
extract <file>  # Extract various archive types
```

### Prompt
Simple, clean prompt showing:
- Current directory (blue)
- Git branch (yellow, when in a repo)
- Prompt symbol (green ❯)

## Customization

### Local Customizations
Create `~/.zshrc.local` for machine-specific settings that won't be version controlled:

```bash
# Example ~/.zshrc.local
export WORK_DIR="/path/to/work/projects"
alias work="cd $WORK_DIR"

# Machine-specific environment variables
export API_KEY="your-local-api-key"
```

### Adding Enhancements
The setup is designed to be minimal but extensible. Popular additions:

1. **Starship prompt**: More advanced prompt with git status, time, etc.
2. **Oh My Zsh**: Plugin ecosystem with themes
3. **fzf**: Fuzzy file finder
4. **exa**: Modern replacement for ls
5. **bat**: Syntax-highlighted cat replacement

## Node.js Management

Node.js is installed via nvm (Node Version Manager):

```bash
# Install latest LTS
nvm install --lts

# Install specific version
nvm install 18.17.0

# Switch versions
nvm use 18.17.0

# Set default
nvm alias default 18.17.0

# List installed versions
nvm list
```

## Maintenance

### Updating
```bash
cd ~/dotfiles
git pull origin main
./install.sh  # Re-run to update plugins and tools
```

### Backing Up
Your dotfiles are already in Git! Just commit and push changes:

```bash
cd ~/dotfiles
git add .
git commit -m "Update configuration"
git push origin main
```

### New Machine Setup
1. Clone your dotfiles repo
2. Run `./install.sh`
3. Update git config with your credentials
4. Done!

## Troubleshooting

### Shell Not Changed
If zsh isn't your default shell after installation:
```bash
chsh -s $(which zsh)
```
Then log out and back in.

### nvm Command Not Found
Restart your terminal or:
```bash
source ~/.zshrc
```

### Permission Issues
Make sure install script is executable:
```bash
chmod +x install.sh
```

## Platform-Specific Notes

### macOS
- Uses Homebrew for package management
- Includes macOS-specific aliases for Finder and DNS
- Works with both Intel and Apple Silicon Macs

### WSL/Linux
- Uses apt for package management
- Includes Linux-specific color settings
- Detects WSL environment automatically

## Security Note

The git configuration includes `credential.helper = store` for convenience. This stores credentials in plain text. For better security, consider using:
- SSH keys for Git authentication
- Git credential helpers specific to your platform
- Personal access tokens instead of passwords
