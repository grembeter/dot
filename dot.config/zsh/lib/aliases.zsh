alias 0='sudo'
alias 0v='sudo vim'

alias 1s='aptitude search'
alias 1h='aptitude show'
alias 1l='aptitude search "~U"'
alias 1p='aptitude install -y --without-recommends --simulate --show-versions'

alias 1u='sudo aptitude update && sudo aptitude search "~N"'
alias 1i='sudo aptitude install --prompt --without-recommends --show-versions'
alias 1g='sudo aptitude safe-upgrade'

alias 2e='. ~/bin/env-bitbake'
alias 2s='test -d $(dirname $(readlink $BUILDDIR/.layersrootenv)) && cd $(dirname $(readlink $BUILDDIR/.layersrootenv))'

alias 5s='repo sync --no-clone-bundle --verbose'

alias cd='cd -P'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../..'                             # same as previous

alias ls='ls --color'
alias ll='ls --color -l'
alias l='ls --color -l --almost-all'

alias h='cat $HISTFILE | grep --color -E -e'
alias df='df --human-readable --print-type --portability'
alias fx='find . -type f -print0 | xargs -n10 -0 grep --color -nH'
alias fn='find . -name'
alias fni='find . -iname'
alias cal='ncal -Mb'
alias grep='grep --color'
alias xclip='xclip -selection clipboard'
alias bat='batcat'

alias g='git'
alias gdif='git diff --no-index'
alias picog='picocom --imap lfcrlf --omap crlf'

alias ttyusb='ll /dev/ttyUSB?'
alias ttyusbof='lsof /dev/ttyUSB?'

alias reboot='sudo -k reboot'
alias poweroff='sudo -k poweroff'
