# -*- mode: sh -*-

autoload -Uz compinit
compinit

HISTSIZE=10000              # the maximum number of events stored in the internal
                            # history list
SAVEHIST=100000             # the maximum number of history events to save in the
                            # history file
HISTFILE=~/.zhist

setopt AUTO_PUSHD           # push the current directory visited on the stack
setopt PUSHD_IGNORE_DUPS    # do not store duplicates in the stack
setopt PUSHD_SILENT         # do not print the directory stack after pushd or popd
setopt HIST_SAVE_NO_DUPS    # when writing out the history file, older commands
                            # that duplicate newer ones are omitted
setopt HIST_IGNORE_SPACE    # remove command lines from the history list when
                            # the first character on the line is a space
setopt HIST_IGNORE_DUPS     # do not enter command lines into the history list
                            # if they are duplicates of the previous event
setopt HIST_IGNORE_ALL_DUPS # if a new command line being added to the history
                            # list duplicates an older one, the older command is
                            # removed from the list (even if it is not the
                            # previous event).

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

z-chdir-parent() {
    cd -P ..
    zle reset-prompt
}

zle -N z-chdir-parent
bindkey '^[[1;5A' z-chdir-parent                  # C-Up

typeset -U path
path=(~/x $path)
export PATH

z-set-prompt() {
    local color="${1:-$PROMPT_COLOR_DEFAULT}"
    local mark="${2:-✔}"

    prompt='%(?.%K{'"${color}"'}%F{016} '"${mark}"' %f%k %F{'"${color}"'}%m%f %F{'"${color}"'}Ξ%f.%K{009}%F{016} ✗ %f%k %F{'"${color}"'}%m%f %F{009}‼%f) %F{010}%/%f
 ; '
}

PROMPT_COLOR_DEFAULT="006"
PROMPT_COLOR_BITBAKE="012"
PROMPT_COLOR_BAREMETAL="011"

source "$HOME/.zalias"

z-set-prompt "$PROMPT_COLOR_DEFAULT"

#
# keep the posibility to store some staff apart
#
if [ -f ~/.config/zshrc ]; then
    source ~/.config/zshrc
fi
