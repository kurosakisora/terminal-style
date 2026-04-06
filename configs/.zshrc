#!/bin/zsh
# ─── Homebrew ────────────────────────────────────────────────────────
eval "$(/opt/homebrew/bin/brew shellenv)"

# ─── Zsh plugins (via Homebrew) ──────────────────────────────────────
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
autoload -Uz compinit && compinit
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ─── History ─────────────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# ─── Starship prompt ────────────────────────────────────────────────
eval "$(starship init zsh)"

# ─── fzf ─────────────────────────────────────────────────────────────
source <(fzf --zsh)

# ─── Zoxide (smart cd) ──────────────────────────────────────────────
eval "$(zoxide init zsh)"

# ─── Aliases ─────────────────────────────────────────────────────────
alias ls='lsd'
alias ll='lsd -la'
alias lt='lsd --tree'
alias cd='z'
alias cat='bat'
alias abc='q'

# ─── Proxy helper ───────────────────────────────────────────────────
proxy () {
    export HTTP_PROXY=http://127.0.0.1:10808
    export HTTPS_PROXY=http://127.0.0.1:10808
    export ALL_PROXY=socks5://127.0.0.1:10808
    "$@"
    unset HTTP_PROXY HTTPS_PROXY ALL_PROXY
}

# ─── Extra PATH ─────────────────────────────────────────────────────
export PATH="/opt/homebrew/opt/mysql-client/bin:$HOME/.local/bin:$PATH"
