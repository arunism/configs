# Set $PATH for custom binaries (if needed)
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnosterzak"

# Enable plugins
plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Run fastfetch for system info
fastfetch -c $HOME/.config/fastfetch/config.jsonc

# Use lsd for better file listings
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Fuzzy search with FZF (CTRL+R)
source <(fzf --zsh)

# Zsh history settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
