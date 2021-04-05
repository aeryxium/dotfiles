# $ZDOTDIR/zsh.d/pkgs.zsh
#
# Functions for dealing with package files.

# -- User functions

# Calls aur sync with default options
# Arguments:
#     AUR package name or 'aur sync' operation (ie '-u')
function aursync() {
	(( $# == 0 )) && _aur_err "No AUR package name or operation provided." && return 1
	aur sync --no-view --sign --remove --chroot "$@"
	return $?
}

# Signs a package file
# Arguments:
#     Package filename
function signpkg() {
	(( $# == 0 )) && _aur_err "No package provided." && return 1
	gpg --detach-sign --yes "$@" 2>/dev/null || _aur_err "Failed signing package $@" && return 1
	return 0
}

# Signs local repo databases
# Arguments:
#     None
function signrepo() {
	[[ -z "${_aur_repo}" ]] && _aur_getrepo
	local hasError="false"
	gpg --detach-sign --yes "${repo_dir}/${repo_name}.db"            || hasError="true"
	gpg --detach-sign --yes "${repo_dir}/${repo_name}.db.tar.zst"    || hasError="true"
	gpg --detach-sign --yes "${repo_dir}/${repo_name}.files"         || hasError="true"
	gpg --detach-sign --yes "${repo_dir}/${repo_name}.files.tar.zst" || hasError="true"
	[[ "$hasError" = "true" ]] && _aur_err "Failed signing one of more repo databases." && return 1
	return 1
}

# Adds a package file to the local repository
# Arguments:
#     Package filename
function repoadd() {
	_aur_getrepo
	for pkg in "$@"; do
		[[ ! -f "$pkg" ]] || _aur_err "$pkg is not a file." && return 1
		pkg="$(readlink -f "$pkg")"
		[[ ! -f "${pkg}.sig" ]] && signpkg "$pkg"
		[[ "$(dirname "$pkg")" != "$_aur_repo_dir" ]]   &&
			cp "$pkg" "${pkg}.sig" "$_aur_repo_dir" &&
			pkg="${_aur_repo_dir}/$(basename "$pkg")"
		repo-add "$_aur_repo" "$pkg"
	done
	signrepo
	return 0
}

# -- Helper functions

# Displays an error message and exits
# Arguments:
#    The error missage to display
function _aur_err() {
	printf "%sERROR:%s %s\n" "$(tput setaf 1)" "$(tput sgr0)" "$@" >&2
}

# Gets the information for the local repo
# Arguments:
#     None
# Sets:
#     _aur_repo_name - name of the repo
#     _aur_repo_dir  - directory containing the repo
#     _aur_repo      - primary database file for the repo
function _aur_getrepo() {
	_aur_db_file=/tmp/db
	aur repo --list --status-file=${_aur_db_file} 1>/dev/null
	[[ ! -f ${_aur_db_file} ]]  && _aur_err "No local repo found." && return 1
	{ IFS=: read -r _aur_repo_name
	  IFS=: read -r _aur_repo_dir
	} <${_aur_db_file}
	rm "${_aur_db_file}"
	_aur_repo="${_aur_repo_dir}/${_aur_repo_name}.db.tar.zst"
	[[ ! -f "${_aur_repo}" ]] && _aur_err "No local repo found." && return 1
	return 0
}
