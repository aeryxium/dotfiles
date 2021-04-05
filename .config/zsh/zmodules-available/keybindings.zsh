# $ZDOTDIR/zsh.d/keybindings.zsh
#
# zsh keybindings.

# Standard terminals
bindkey "\e[A" up-line-or-beginning-search
bindkey "\e[B" down-line-or-beginning-search
bindkey "\e[1~" beginning-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[F" end-of-line
bindkey "\e[3~" delete-char
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e[5~" history-beginning-search-backward
bindkey "\e[6~" history-beginning-search-forward

# Non-standard terminals
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search        # Up
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search      # Down
bindkey "${terminfo[khome]}" beginning-of-line                  # Home
bindkey "${terminfo[kend]}" end-of-line                         # End
bindkey "${terminfo[kdch1]}" delete-char                        # Delete
bindkey "${terminfo[kpp]}" history-beginning-search-backward    # PageUp
bindkey "${terminfo[knp]}" history-beginning-search-forward     # PageDn

# Fix delete
bindkey "^[[P" delete-char
