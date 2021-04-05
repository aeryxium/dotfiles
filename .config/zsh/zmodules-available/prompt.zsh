# $ZDOTDIR/zsh.d/prompt.zsh
#
# zsh prompt.

if [[ -z "$SSH_TTY" ]]; then
	unset RPROMPT
else
	RPROMPT=$'%F{blue}[%F{green}via %F{1}b%F{214}i%F{3}f%F{2}r%F{4}ö%F{6}s%F{5}t%F{blue}]'
fi
set_prompt () {
	if [[ -w "." ]]; then
		PROMPT=$'%F{blue}┌[%F{green}%~%F{blue}]\n└[%(#.%F{red}odin.%F{green}%n)@%m%F{blue}] %# %f'
	else
		PROMPT=$'%F{blue}┌[%F{red}%~%F{blue}]\n└[%(#.%F{red}odin.%F{green}%n)@%m%F{blue}] %# %f'
	fi
}
add-zsh-hook precmd set_prompt
