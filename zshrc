# -*- mode: sh -*-

autoload -Uz compinit
compinit

HISTFILE=~/.zhist
HISTSIZE=1000
SAVEHIST=10000

setopt AUTO_PUSHD           # push the current directory visited on the stack
setopt PUSHD_IGNORE_DUPS    # do not store duplicates in the stack
setopt PUSHD_SILENT         # do not print the directory stack after pushd or popd

setopt notify
unsetopt beep
bindkey -e

if [ -e ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE} ]; then
    source ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}
else
    echo '::::: autoload zkbd && zkbd'
fi

[[ -n "$key[Home]" ]]      && bindkey -- "$key[Home]"      beginning-of-line
[[ -n "$key[End]" ]]       && bindkey -- "$key[End]"       end-of-line
[[ -n "$key[Insert]" ]]    && bindkey -- "$key[Insert]"    overwrite-mode
[[ -n "$key[Delete]" ]]    && bindkey -- "$key[Delete]"    delete-char
[[ -n "$key[Backspace]" ]] && bindkey -- "$key[Backspace]" backward-delete-char
[[ -n "$key[Left]" ]]      && bindkey -- "$key[Left]"      backward-char
[[ -n "$key[Right]" ]]     && bindkey -- "$key[Right]"     forward-char

autoload -Uz up-line-or-beginning-search
zle -N up-line-or-beginning-search

autoload -Uz down-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "$key[Up]" ]]   && bindkey -- "$key[Up]"   up-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

bindkey '^[[1;3D' emacs-backward-word             # M-Left
bindkey '^[[1;3C' emacs-forward-word              # M-Right
bindkey '^[[3;3~' kill-word                       # M-Del

gr-chdir-parent() {
    cd -P ..
    zle reset-prompt
}

zle -N gr-chdir-parent
bindkey '^[[1;5A' gr-chdir-parent                 # C-Up

export PATH="$HOME/x:$PATH"

PROMPT='%(?.%K{cyan}%F{black} ≡ %f%k %F{cyan}%m%f %F{cyan}▼%f.%K{red}%F{black} %? %f%k %F{cyan}%m%f %F{red}‼%f) %F{green}%/%f
 » '
RPROMPT='%D{%H:%M}'

source "$HOME/.zalias"

#
# keep the posibility to store some staff apart
#
if [ -f ~/.config/zshrc ]; then
    source ~/.config/zshrc
fi
