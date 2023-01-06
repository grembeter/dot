# -*- mode: sh -*-

autoload -Uz compinit
compinit

HISTSIZE=10000              # the maximum number of events stored in the internal
                            # history list
SAVEHIST=100000             # the maximum number of history events to save in the
                            # history file
HISTFILE="$HOME/.zhist"

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
                            # previous event)
setopt NOTIFY               # report the status of background jobs immediately,
                            # rather than waiting until just before printing a
                            # prompt
unsetopt beep
bindkey -e

typeset -U path

# prepend user path
path=("$HOME/bin" $path)
export PATH

test -f "$HOME/.zlib"   && source "$HOME/.zlib"

if [ -e "$HOME/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}" ]; then
    source "$HOME/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}"
else
    echo "tip: autoload zkbd && zkbd"
fi

autoload -Uz up-line-or-beginning-search
zle -N up-line-or-beginning-search

autoload -Uz down-line-or-beginning-search
zle -N down-line-or-beginning-search

test -n "$key[Home]"       && bindkey -- "$key[Home]"       beginning-of-line
test -n "$key[End]"        && bindkey -- "$key[End]"        end-of-line
test -n "$key[Insert]"     && bindkey -- "$key[Insert]"     overwrite-mode
test -n "$key[Delete]"     && bindkey -- "$key[Delete]"     delete-char
test -n "$key[Backspace]"  && bindkey -- "$key[Backspace]"  backward-delete-char
test -n "$key[Left]"       && bindkey -- "$key[Left]"       backward-char
test -n "$key[Right]"      && bindkey -- "$key[Right]"      forward-char
test -n "$key[Up]"         && bindkey -- "$key[Up]"         up-line-or-beginning-search
test -n "$key[Down]"       && bindkey -- "$key[Down]"       down-line-or-beginning-search

bindkey '^[[1;3D' emacs-backward-word             # M-Left
bindkey '^[[1;3C' emacs-forward-word              # M-Right
bindkey '^[[3;3~' kill-word                       # M-Del

zle -N g-chdir-parent
bindkey '^[[1;5A' g-chdir-parent                  # C-Up

g-set-prompt "$PROMPT_COLOR_DEFAULT"

#
# keep the posibility to store some staff apart
#
test -f "$HOME/.config/zshrc" && source "$HOME/.config/zshrc"

# return true
:
