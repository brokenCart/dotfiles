#
# ~/.bashrc — Catppuccin Mocha / starship setup
# (pre-rice version: ~/.config-backups/2026-11-21/.bashrc.bak-2026-11-21)
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ── History ──────────────────────────────────────────────────────
HISTSIZE=50000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups      # skip duplicates and lines starting with a space
HISTIGNORE="ls:ll:la:cd:pwd:exit:clear:c"
HISTTIMEFORMAT="%F %T  "
shopt -s histappend cmdhist           # share history across terminals, keep multi-line cmds
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# ── Shell behaviour ──────────────────────────────────────────────
shopt -s autocd cdspell dirspell      # type a dir name to cd into it, fix small cd typos
shopt -s globstar extglob nocaseglob  # ** recursion, smarter globs
shopt -s checkwinsize
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'set colored-stats on'
bind 'set colored-completion-prefix on'
bind 'set mark-symlinked-directories on'
bind '"\e[A": history-search-backward'  # ↑/↓ search history by what you've typed
bind '"\e[B": history-search-forward'

[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

# ── Environment ──────────────────────────────────────────────────
export EDITOR=nano
export VISUAL=code
export PAGER=less
export LESS='-R --mouse'
export BAT_THEME="Catppuccin Mocha"
command -v bat >/dev/null && export MANPAGER="sh -c 'col -bx | bat -l man -p'" MANROFFOPT="-c"

# ── Aliases ──────────────────────────────────────────────────────
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'

if command -v eza >/dev/null; then
    alias ls='eza --icons=auto --group-directories-first'
    alias ll='eza -l --icons=auto --group-directories-first --git --time-style=relative'
    alias la='eza -la --icons=auto --group-directories-first --git --time-style=relative'
    alias lt='eza --tree --level=2 --icons=auto --group-directories-first'
else
    alias ls='ls --color=auto'
    alias ll='ls -lh'
    alias la='ls -lAh'
fi
command -v bat >/dev/null && alias cat='bat --paging=never --style=plain'

alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Arch
alias update='yay -Syu'
alias orphans='pacman -Qdtq'

# Hyprland / rice
alias hyprconf='$VISUAL ~/.config/hypr/hyprland.lua'
alias reload='hyprctl reload && pkill -SIGUSR2 waybar'

# ── Helpers ──────────────────────────────────────────────────────
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# extract anything: x file.tar.gz
x() {
    case "$1" in
        *.tar.bz2|*.tbz2) tar xjf "$1" ;;
        *.tar.gz|*.tgz)   tar xzf "$1" ;;
        *.tar.xz)         tar xJf "$1" ;;
        *.tar.zst)        tar --zstd -xf "$1" ;;
        *.tar)            tar xf "$1" ;;
        *.bz2)            bunzip2 "$1" ;;
        *.gz)             gunzip "$1" ;;
        *.zip)            unzip "$1" ;;
        *.7z)             7z x "$1" ;;
        *.rar)            unrar x "$1" ;;
        *) echo "x: don't know how to extract '$1'" >&2; return 1 ;;
    esac
}

# ── fzf (Ctrl+R history, Ctrl+T files, Alt+C cd) ─────────────────
if command -v fzf >/dev/null; then
    if command -v fd >/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
    fi
    export FZF_DEFAULT_OPTS="--height 45% --layout=reverse --border=rounded --info=inline-right \
--prompt='❯ ' --pointer='▶' --marker='✓' \
--color=bg+:#313244,bg:-1,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#89dceb \
--color=marker:#a6e3a1,fg+:#cdd6f4,prompt:#89dceb,hl+:#f38ba8 \
--color=border:#45475a,label:#cdd6f4"
    command -v bat >/dev/null && export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
    command -v eza >/dev/null && export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons=always --color=always {}'"
    eval "$(fzf --bash)"
fi

# ── zoxide: `z proj` jumps to your most-used matching dir, `zi` picks with fzf ──
command -v zoxide >/dev/null && eval "$(zoxide init bash)"

# ── Prompt ───────────────────────────────────────────────────────
if command -v starship >/dev/null; then
    eval "$(starship init bash)"
else
    PS1='[\u@\h \W]\$ '
fi
