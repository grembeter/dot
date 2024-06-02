alias 0='sudo'
alias 0v='sudo vim'

alias 1='apt -o APT::Install-Recommends=false'
alias 1s='apt search'
alias 1h='apt show'
alias 1l='apt-cache policy'
alias 1p='apt -o APT::Install-Recommends=false install --verbose-versions --simulate'
alias 1fs='apt-file search'
alias 1fl='apt-file list'

alias 1i='sudo -k apt -o APT::Install-Recommends=false install --verbose-versions'
alias 1u='sudo apt -o APT::Install-Recommends=false update'
alias 1g='sudo apt -o APT::Install-Recommends=false upgrade'
alias 1gg='sudo apt -o APT::Install-Recommends=false full-upgrade'
alias 1x='sudo apt autoremove'
alias 1xx='sudo apt autoremove --purge'

alias 2b='. env-bitbake'
alias 2t='. env-toolchain'
alias 2s='g-chdir-repo'

alias 3='g-ttyusb'
alias 3l='g-ttyusbls'
alias 3o='lsof /dev/ttyUSB?'
alias 3x='ls --color -l /tmp/picocom.*.log'
alias 3xxx='rm -vf /tmp/picocom.*.log'

alias 5s='repo sync --no-clone-bundle --verbose'

alias cd='cd -P'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../..'                             # same as previous

alias ls='ls --color'
alias ll='ls --color -l'
alias l='ls --color -l --almost-all'
alias in='g-lsin'

alias em='emacsclient -a "" -c -n'
alias emt='emacsclient -a "" -t'
alias emx='emacsclient -a "" -c'

alias h='history 0 | grep --color -Ee'
alias df='df --human-readable --print-type --portability'
alias fx='find . -type f -print0 | xargs -n10 -0 grep --color -nH'
alias fn='find . -name'
alias fni='find . -iname'
alias cal='ncal -Mb'
alias grep='grep --color'
alias xclip='xclip -selection clipboard'

alias t='batcat'

alias g='git'
alias gdif='git diff --no-index'

alias reboot='sudo -k reboot'
alias poweroff='sudo -k poweroff'
