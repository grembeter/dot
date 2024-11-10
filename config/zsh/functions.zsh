PROMPT_COLOR_DEFAULT="014"
PROMPT_COLOR_BITBAKE="012"
PROMPT_COLOR_BAREMETAL="011"


#
# set shell prompt
#
g-set-prompt() {
    local color="${1:-$PROMPT_COLOR_DEFAULT}"
    local mark="${2:-»}"
    local prompt_date='%F{010}%D{%H:%M}%f'
    local prompt_true='%F{'"${color}"'}##%f '"$prompt_date"' %F{'"${color}"'}%m%f %F{015}'"${mark}"'%f'
    local prompt_false='%F{009}??%f '"$prompt_date"' %F{'"${color}"'}%m%f %F{009}✗%f'

    prompt="%(?.${prompt_true}.${prompt_false}) %F{010}%/%f
 ; "
}

#
# move to parent dir (for keybinding)
#
g-chdir-parent() {
    cd -P ..
    zle reset-prompt
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
# go to bitbake packages work dir
#
g-chdir-work() {
    for w in "${BUILDDIR:-$PWD}/${2:-tmp}"/work/*/$1/*; do
        test -d "$w" && chdir -P "$w"
        break
    done
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

#
# list the newest files in downloads
#
g-lsin() {
    local dir="$(xdg-user-dir DOWNLOAD)"

    if [ $# -ne 0 ]; then
        ls --color=never -1 --quoting-style=shell-always -t "$dir"/* \
            | cat -n | sort -n \
            | awk -v ORS= '$1 == '"$1"' {$1=""; print}' | xclip -i
    else
        ls -1 --quoting-style=shell-always -t "$dir" | cat -n | sort -n | ${PAGER:-less}
    fi
}
