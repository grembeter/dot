PROMPT_COLOR_DEFAULT="006"
PROMPT_COLOR_BITBAKE="012"
PROMPT_COLOR_BAREMETAL="011"


#
# set shell prompt
#
g-set-prompt() {
    local color="${1:-$PROMPT_COLOR_DEFAULT}"
    local mark="${2:-✔}"

    prompt='%(?.%K{'"${color}"'}%F{016} '"${mark}"' %f%k %F{'"${color}"'}%m%f %F{'"${color}"'}Ξ%f.%K{009}%F{016} ✗ %f%k %F{'"${color}"'}%m%f %F{009}‼%f) %F{010}%/%f
 ; '
}

#
# move to parent dir (for keybinding)
#
g-chdir-parent() {
    cd -P ..
    zle reset-prompt
}

#
# run terminal emulation program with predefined device and baudrate
#
g-picocom() {
    picog "/dev/ttyUSB${1:-0}" -b "${2:-115200}"
}
