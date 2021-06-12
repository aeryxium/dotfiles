#!/bin/zsh

alias lhn="ls ~/notebook/content/slipbox/notes/"

function hnb() {
	if (( $# != 1 )); then
		printf "Only one argument can be passed.\n"
		return
	fi
	if [[ "$@" =~ ( ) ]]; then
		printf "Filename can't contain spaces.\n"
		return
	fi
	filename="$@"
	if [[ ! "$@" =~ .md$ ]]; then
		filename="${filename}.md"
	fi
	pushd ~/notebook
	hugo new -k books content/slipbox/books/"$filename"
	popd
}

function hnn() {
	if (( $# != 1 )); then
		printf "Only one argument can be passed.\n"
		return
	fi
	if [[ "$@" =~ ( ) ]]; then
		printf "Filename can't contain spaces.\n"
		return
	fi
	filename="$@"
	if [[ ! "$@" =~ .md$ ]]; then
		filename="${filename}.md"
	fi
	pushd ~/notebook
	hugo new -k notes content/slipbox/notes/"$filename"
	popd
}

function get_tags() {
	notefiles=( "$HOME"/notebook/content/notes/*.md )
	grep -oh "^tags: .*" ${notefiles[@]} | sed 's/^tags: \[//' | sed 's/\]$//' | sed 's/, /\n/g' | sed 's/"//g' | sort | uniq
}

function syncnotebook() {
	/usr/bin/ssh \
		-ntqF "$XDG_CONFIG_HOME/ssh/config" "$@" \
		aeryxium.com "sudo -S chown -R $USER:$USER /srv/http/notebook"
	rsync --delete \
		-qe "/usr/bin/ssh -F '$XDG_CONFIG_HOME'/ssh/config" \
		-av "$HOME"/notebook/public/ notebook:/srv/http/notebook
	/usr/bin/ssh \
		-ntqF "$XDG_CONFIG_HOME/ssh/config" "$@" \
		aeryxium.com "sudo -S chown -R http:http /srv/http/notebook"
}

function vw() {
	nvim -c 'VimwikiIndex' -c 'VimwikiGoto _index'
#	if echo -e "GET http://notebook.aeryxium.com HTTP/1.0\n\n" | nc notebook.aeryxium.com 80 &>/dev/null; then
#		pushd "$HOME"/notebook && hugo -D --quiet && popd
#		syncnotebook &!
#	fi
}
