# $ZDOTDIR/zsh.d/history.zsh
#
# zsh history configuration.

setopt hist_ignore_dups hist_ignore_space hist_save_no_dups inc_append_history share_history
export HISTFILE=~/.config/zsh/histfile
export HISTSIZE=100000
export SAVEHIST=100000
