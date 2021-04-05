# $ZDOTDIR/zsh.d/git_ssh.zsh
#
# Git- and ssh-related functions.

alias git="GIT_SSH_COMMAND=\"ssh -F $XDG_CONFIG_HOME/ssh/config\" /usr/bin/git"
alias dotfiles="git --git-dir=$HOME/.config/dotfiles --work-tree=$HOME"
alias scp="scp -F \"$XDG_CONFIG_HOME/ssh/config\""
alias ssh="heimdallr"

function heimdallr () {
	echo "Heimdallr! Open the Bifröst!"
	function outputfrost() {
		for i in {1..4}; do
			echo -n "≡"
			sleep 0.03s
		done
	}
	echo -n "[38;5;001m"
	outputfrost
	echo -n "[38;5;214m"
	outputfrost
	echo -n "[38;5;003m"
	outputfrost
	echo -n "[38;5;002m"
	outputfrost
	echo -n "[38;5;004m"
	outputfrost
	echo -n "[38;5;006m"
	outputfrost
	echo -n "[38;5;005m"
	outputfrost
	echo "\n"
	tput sgr0
	/usr/bin/ssh -F "$XDG_CONFIG_HOME/ssh/config" "$@"
}
