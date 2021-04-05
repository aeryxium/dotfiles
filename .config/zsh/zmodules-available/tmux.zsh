# $ZDOTDIR/zsh.d/tmux.zsh
#
# tmux-related functions.

# Prevent tmux from closing with last pane
if [ -n "$TMUX" ]; then
	_exit_maybe() {
		[ "$(tmux list-panes   | wc -l)" -gt 1 ] && exit
		[ "$(tmux list-windows | wc -l)" -gt 1 ] && exit
		tmux detach-client
	}
	zle -N _exit_maybe _exit_maybe
	bindkey -s "^D" ""
	bindkey "" _exit_maybe
else
	bindkey "^D" exit
fi

# Connect to default tmux session by default if it exists
function tmux() {
	if [[ "$#" = "0" ]] || ( [[ "$#" = "1" && "$@" = "a" ]] ); then
		if /usr/bin/tmux ls 2>/dev/null | grep -q ^aeryxium; then
			/usr/bin/tmux a -t aeryxium
		else
			/usr/bin/tmux new-session -s aeryxium
		fi
	else
		/usr/bin/tmux "$@"
	fi
}
