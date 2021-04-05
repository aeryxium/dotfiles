# $ZDOTDIR/zsh.d/encryption.zsh
#
# Functions for managing private directory encrypted before uploading to git.

function _chk_encryption_dirs() {
	if [[ ! -d ~/.private ]]; then
		printf "ERROR: Directory ~/.private is missing. Aborting.\n" >&2
		return 1
	fi
	if [[ ! -d ~/.encrypted ]]; then
		printf "ERROR: Directory ~/.encrypted is missing. Aborting.\n" >&2
		return 1
	fi
	return 0
}

alias _git_e='git --git-dir="$HOME/.encrypted/.git" --work-tree="$HOME/.encrypted"'

function git-decrypt() {
	if ! _chk_encryption_dirs; then
		return 1
	fi
	git --git-dir=$HOME/.encrypted/.git pull        &>/dev/null &&
		gpg -d $HOME/.encrypted/private.tgz.gpg &>/dev/null |
		tar -C ~/.private -xz                   &>/dev/null
}

function git-encrypt() {
	if ! _chk_encryption_dirs; then
		return 1
	fi
	tar -C ~/.private -czv . &>/dev/null |
		gpg -se -r 4F43DB07953714DB --yes --trust-model always  \
			-o ~/.encrypted/private.tgz.gpg     &>/dev/null &&
		_git_e add $HOME/.encrypted/private.tgz.gpg &>/dev/null &&
		_git_e commit -m "$(date)"                  &>/dev/null &&
		_git_e push                                 &>/dev/null
}

function git-encrypt-setup() {
	if _chk_encryption_dirs &>/dev/null; then
		printf "ERROR: Encrypted git repo already setup." >&2
		return 1
	fi
	mkdir ~/.private &>/dev/null && mkdir ~/.encrypted &>/dev/null
	if ! git clone "git@github.com:aeryxium/private" ~/.encrypted &>/dev/null; then
		printf "ERORR: Failed to clone repo.\n"
		return 1
	fi
	git-decrypt
}

