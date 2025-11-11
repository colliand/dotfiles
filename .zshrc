# ~/.zshrc - Main Zsh Configuration
# Modular, cross-platform dotfiles setup

# =====================================================
# PLATFORM DETECTION
# =====================================================
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]] || [[ -n "$WSL_DISTRO_NAME" ]]; then
    PLATFORM="linux"
fi

# =====================================================
# HISTORY CONFIGURATION
# =====================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Share history across all sessions
setopt SHARE_HISTORY
# Append to history file immediately, not on shell exit
setopt INC_APPEND_HISTORY
# Remove older duplicates from history
setopt HIST_EXPIRE_DUPS_FIRST
# Don't record duplicates
setopt HIST_IGNORE_DUPS
# Remove superfluous blanks
setopt HIST_REDUCE_BLANKS
# Verify history expansion before executing
setopt HIST_VERIFY

# =====================================================
# COMPLETION SYSTEM
# =====================================================
# Initialize completion system
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# Menu-style completion
zstyle ':completion:*' menu select
# Color completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Complete . and .. special directories
zstyle ':completion:*' special-dirs true

# =====================================================
# PROMPT CONFIGURATION
# =====================================================
# Enable parameter expansion, command substitution and arithmetic expansion in prompts
setopt PROMPT_SUBST

# Git branch function
git_branch() {
    local branch
    if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
        if [[ "$branch" == "HEAD" ]]; then
            branch='detached*'
        fi
        echo " (%{$fg[yellow]%}$branch%{$reset_color%})"
    fi
}

# Load colors
autoload -U colors && colors

# Simple, clean prompt with git info
PROMPT='%{$fg[blue]%}%c%{$reset_color%}$(git_branch) %{$fg[green]%}❯%{$reset_color%} '

# =====================================================
# ENVIRONMENT VARIABLES
# =====================================================
# Editor
export EDITOR='vim'
export VISUAL='vim'

# Less colors (for man pages, etc.)
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# =====================================================
# NVM (Node Version Manager)
# =====================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# =====================================================
# PLATFORM-SPECIFIC CONFIGURATION
# =====================================================
if [[ "$PLATFORM" == "macos" ]]; then
    # Homebrew
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    # macOS-specific aliases
    alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
    alias flushdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
    
elif [[ "$PLATFORM" == "linux" ]]; then
    # Linux-specific configuration
    # Enable color support for ls
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    fi
fi

# =====================================================
# ALIASES
# =====================================================
# Basic aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mm='micromamba'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Git aliases (basic set)
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Navigation
alias ~='cd ~'
alias c='clear'
alias h='history'

# Directory listing with colors (platform-specific)
if [[ "$PLATFORM" == "macos" ]]; then
    alias ls='ls -G'
elif [[ "$PLATFORM" == "linux" ]]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# =====================================================
# FUNCTIONS
# =====================================================
# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick file/directory search
qfind() {
    find . -name "*$1*" 2>/dev/null
}

# Extract various archive types
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# =====================================================
# ZSH PLUGINS
# =====================================================
# Load zsh-syntax-highlighting (must be last)
if [[ -f ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Load zsh-autosuggestions
if [[ -f ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    # Customize autosuggestions
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
fi

# =====================================================
# LOCAL CUSTOMIZATIONS
# =====================================================
# Load local customizations if they exist
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

# Terminal themes directory
THEMES_DIR="$HOME/dotfiles/zsh/themes"

# Function to change theme
change_theme() {
    if [ -n "$1" ] && [ -f "$THEMES_DIR/$1.zsh-theme" ]; then
        cp "$THEMES_DIR/$1.zsh-theme" ~/.zshrc.local
        source ~/.zshrc.local
        echo "Theme changed to $1"
    else
        echo "Invalid theme name or file not found"
    fi
}

# Default theme
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
else
    cp "$THEMES_DIR/default.zsh-theme" ~/.zshrc.local
    source ~/.zshrc.local
fi

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/opt/homebrew/opt/micromamba/bin/mamba';
export MAMBA_ROOT_PREFIX='/Users/colliand/mamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
export PATH="/opt/homebrew/bin:$PATH"

# Created by `pipx` on 2025-11-10 05:03:37
export PATH="$PATH:/Users/colliand/.local/bin"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# Add a trailing newline for consistency
