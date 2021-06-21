## .keybind.zsh - zsh key bindings fix
# Taken from http://zshwiki.org/home/zle/bindkeys#reading_terminfo
# and from https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/key-bindings.zsh

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"       ]]  && bindkey  "${key[Home]}"        beginning-of-line
[[ -n "${key[End]}"        ]]  && bindkey  "${key[End]}"         end-of-line
[[ -n "${key[Insert]}"     ]]  && bindkey  "${key[Insert]}"      overwrite-mode
[[ -n "${key[Delete]}"     ]]  && bindkey  "${key[Delete]}"      delete-char
[[ -n "${key[Up]}"         ]]  && bindkey  "${key[Up]}"          up-line-or-history
[[ -n "${key[Down]}"       ]]  && bindkey  "${key[Down]}"        down-line-or-history
[[ -n "${key[Left]}"       ]]  && bindkey  "${key[Left]}"        backward-char
[[ -n "${key[Right]}"      ]]  && bindkey  "${key[Right]}"       forward-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '[C' forward-word
bindkey '[D' backward-word
bindkey ' ' magic-space

# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if [[ -n ${terminfo[smkx]} ]] && [[ -n ${terminfo[rmkx]} ]]; then
    function zle-line-init () {
        echoti smkx
    }

    function zle-line-finish () {
        echoti rmkx
    }

    zle -N zle-line-init
    zle -N zle-line-finish
fi
