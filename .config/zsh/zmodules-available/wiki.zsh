#!/bin/zsh

# -- VimWiki
alias vw="nvim -c 'VimwikiIndex 1'"

# -- zettelkasten SCRatchbox
function scr() {
	PREFIX="$(date +%Y%m%d%H)"
	POSTFIX=0000
	while [[ -f "$HOME/wiki/slipbox/${PREFIX}-${POSTFIX}" ]]; do
		POSTFIX="$(printf %04d $(( ++POSTFIX )) )"
	done
	if (( $# == 0 )); then
		nvim -c "VimwikiIndex 2" -c "ZettelNew ${PREFIX}-${POSTFIX}"
		return 0
	fi
	nvim -c "VimwikiIndex 2" -c "ZettelNew ${PREFIX}-${POSTFIX}-$*"
	return 0
}

# -- ZETtelkasten
function zet() {
	if (( $# < 1 )); then
		nvim -c "VimwikiIndex 2"
		return 0
	fi
	nvim -c "VimwikiIndex 3" -c "ZettelNew $*"
}
