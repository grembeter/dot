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

#
# move to layers root dir
#
# A convenient way to move to repo directory in bitbake environment.
# $BUILDDIR is set by OE environment setup script and .layersrootenv
# symlink is created by env-bitbake setup script.
#
g-chdir-repo() {
    local layersrootenv="${BUILDDIR:-$PWD}"/.layersrootenv
    test -L "$layersrootenv" || return
    layersrootenv=$(dirname $(readlink "$layersrootenv"))
    test -d "$layersrootenv" && cd "$layersrootenv"
}

#
# show path to bitbake packages work dir
#
g-list-work() {
    ls --directory "${BUILDDIR:-$PWD}/${2:-tmp}"/work/*/$1/*
}

#
# list ipk files
#
g-ipk-data() {
    local pkg
    for pkg in "$@"; do
        test -f "$pkg" || continue
        echo "# $pkg"
        ar p "$pkg" data.tar.xz | tar Jtf -
    done
}

#
# show ipk control file
#
g-ipk-control() {
    local pkg
    for pkg in "$@"; do
        test -f "$pkg" || continue
        echo "# $pkg"
        ar p "$pkg" control.tar.gz | tar zxOf - ./control
    done
}

#
# search through ipk packages
#
g-ipk-regexp() {
    local regexp="${1:-^Depends: .*bash}"
    local ipkdir="${2:-$PWD}"
    local pkg

    for pkg in $(find "$ipkdir" -name "*.ipk" | sort); do
        test -f "$pkg" || continue
        ar p "$pkg" control.tar.gz | tar zxOf - ./control \
            | perl -sne 'print "# $pkg\n$_" if (/$regexp/)' \
                   -- -regexp="$regexp" -pkg="$pkg"
    done
}

#
# show ipk packages, that have specified dependencies
#
g-ipk-depends() {
    local regexp="^Depends: .*$1"
    local ipkdir="${2:-$PWD}"

    g-ipk-regexp "$regexp" "$ipkdir"
}
