# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="refined"

plugins=( 
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# My alias 
alias cty='tty-clock -S -c -C 6 -t -n -D'
alias fucking='sudo'
alias n='nvim'
alias ll='ls -Alh'
alias cat='bat'
alias gc='g++ -o o'
alias py='python3'
alias c='sudo rsync -avhW --no-compress --progress '
alias code='code --ozone-platform=x11'
alias kiro='kiro --ozone-platform=x11'
alias y='yazi'
alias md1='sudo mount /dev/sda5 /mnt/vmachines'
alias md2='sudo mount /dev/sda4 /mnt/windows-drive'
alias web='tmuxifier load-session web-dev'
alias lg='lazygit'
alias tk='tmux kill-server'
alias ntest='bash /home/ahmad/.config/hypr/UserScripts/networkTest.sh'
alias server='ssh -i ~/.ssh/ssh-key-2025-09-06.key ubuntu@140.245.24.242'

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory


# exports
export LC_TIME=ur_PK.UTF-8
export PATH="$HOME/.tmuxifier/bin:$PATH"
export LIBVIRT_DEFAULT_URI='qemu:///system'
# eval "$(zoxide init zsh)"
# eval "$(tmuxifier init -)"
export PATH=$PATH:/home/ahmad/.spicetify
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
