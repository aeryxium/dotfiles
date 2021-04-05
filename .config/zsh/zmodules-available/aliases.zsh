# $ZDOTDIR/zsh.d/aliases.zsh
#
# Basic aliases for zsh.

alias dotfiles="git --git-dir=\"$HOME/.config/dotfiles\" --work-tree=\"$HOME\""
alias ls="LC_COLLATE=C /usr/bin/ls --color=auto -hv --group-directories-first"
alias nv="/usr/bin/nvim"
alias sudo="/usr/bin/sudo "

alias acp="/usr/bin/advcp -g"
alias amv="/usr/bin/advmv -g"
alias df="/usr/bin/df -h"
alias du="/usr/bin/du -h"
alias sort="/usr/bin/sort -h"

alias mkdiff="diff -U 99999"

alias startx="/usr/bin/dbus-launch --exit-with-session /usr/bin/startx \"$XINITRC\" &>/dev/null"
