# ~/.zshrc - Minimal & Aesthetic ZSH Config

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Completion system
autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
setopt AUTO_CD
setopt GLOB_COMPLETE

# Key bindings for history search
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Git info function with status symbols
git_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
        local git_status=""
        
        # Check for various git states
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            # Staged changes
            if git diff --cached --quiet 2>/dev/null; then
                :
            else
                git_status+="+"
            fi
            
            # Modified files
            if git diff --quiet 2>/dev/null; then
                :
            else
                git_status+="!"
            fi
            
            # Untracked files
            if [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
                git_status+="?"
            fi
        fi
        
        # Ahead/behind remote
        local ahead_behind=$(git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)
        if [[ -n "$ahead_behind" ]]; then
            local ahead=$(echo $ahead_behind | cut -f1)
            local behind=$(echo $ahead_behind | cut -f2)
            [[ $ahead -gt 0 ]] && git_status+="↑"
            [[ $behind -gt 0 ]] && git_status+="↓"
        fi
        
        echo " ($branch$git_status)"
    fi
}

# Ultra-minimal prompt: ~ > with git info after path
setopt PROMPT_SUBST
PROMPT='%F{4}%~%f%F{3}$(git_info)%f
%F{7}>%f '

# Syntax highlighting (load at end)
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Useful aliases
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias tree='tree -C'
alias bat='bat --theme=ansi'

# Development aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'

# Quick directory navigation
alias proj='cd ~/Projects'
alias down='cd ~/Downloads'
alias docs='cd ~/Documents'

# System info
alias sys='fastfetch'
alias ports='ss -tuln'
alias usage='du -h --max-depth=1 | sort -hr'

# Create directories and navigate
mkcd() { mkdir -p "$1" && cd "$1"; }

# Extract function for various archives
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval $(thefuck --alias)
fastfetch
alias ls='eza --icons'
alias la='eza -la --icons --git'
alias tree='eza --tree'
alias osage='birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days'
alias factorio='cd ~/Games/F:SA/Factorio_Linux/factorio-space-age_linux_2.0.60/factorio/bin/x64; factorio; cd -'

export PATH=$PATH:/home/nishchalravi/.spicetify
