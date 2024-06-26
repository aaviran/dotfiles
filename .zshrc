## .zshrc

## Initial settings and variabls
autoload -Uz colors && colors
autoload -Uz compinit && compinit
autoload -Uz select-word-style && select-word-style bash


DOTFILES_DIR="${HOME}/dotfiles"
ALIAS_PATH="${DOTFILES_DIR}/.alias"
ENV_ALIAS_PATH="${DOTFILES_DIR}/.alias.env"
ZSH_ALIAS_PATH="${DOTFILES_DIR}/.alias.zsh"
ZSH_GIT_PROMPT_DIR="${HOME}/dev/external/zsh-git-prompt"
ZSH_AUTOSUGGESTIONS_DIR="/opt/homebrew/share/zsh-autosuggestions"
ZSH_SYNTAX_HIGHLIGHTING_DIR="/opt/homebrew/share/zsh-syntax-highlighting"
ZSH_YARN_AUTOCOMPLETIONS_DIR="/Users/aaviran/zsh-plugins/yarn-autocompletions"
ZSH_KEYBIND_PATH="${DOTFILES_DIR}/.keybind.zsh"
DIRCOLORS_PATH=/usr/bin/dircolors
COWFILES_PATH="${HOME}/dev/external/cowsay-files/cows"

export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"
export BROWSER="google-chrome-unstable"
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
export GOPATH="${HOME}/dev/go"
export PATH="${PATH}:${GOPATH}/bin:${HOME}/bin"
export GPG_TTY
GPG_TTY=$(tty)

if [[ -d "$COWFILES_PATH" ]]; then
  export COWPATH="/usr/share/cows:${COWFILES_PATH}"
fi

# less colors
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# ls colors
[[ -f "$DIRCOLORS_PATH" ]] && eval $("$DIRCOLORS_PATH")

## Prompt
PROMPT="%{$fg_bold[red]%}[%{$fg_bold[white]%}%*%{$fg_bold[red]%}] [%{$fg_bold[white]%}%n%{$fg_bold[blue]%}@%{$fg_bold[white]%}%m%{$fg_bold[red]%}] %{$fg_bold[blue]%}%#%{$reset_color%} "
RPROMPT="%(?..%{$fg_bold[red]%}[%{$fg_bold[yellow]%}%? %{$fg_bold[white]%}:/%{$fg_bold[red]%}] )%{$fg_bold[red]%}[%{$fg_bold[white]%}%~%{$fg_bold[red]%}]%{$reset_color%}"

# Git prompt
if [[ -d "$ZSH_GIT_PROMPT_DIR" ]]; then
  if [[ -f "${ZSH_GIT_PROMPT_DIR}/src/.bin/gitstatus" ]]; then
    GIT_PROMPT_EXECUTABLE="haskell"
  fi
  source "${ZSH_GIT_PROMPT_DIR}/zshrc.sh"

  ZSH_THEME_GIT_PROMPT_PREFIX=" %{${fg_bold[red]}%}["
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{${fg_bold[red]}%}]%{${reset_color}%}"
  ZSH_THEME_GIT_PROMPT_SEPARATOR="%{${fg_bold[red]}%}|"
  ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[white]%}"
  ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}%{S%G%}"
  ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg_bold[red]%}%{C%G%}"
  ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg_bold[yellow]%}%{M%G%}"
  ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
  ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"
  ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[blue]%}%{U%G%}"
  ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}🤷"
  RPROMPT="${RPROMPT}\$(git_super_status)"
fi

# Fast ssh-add
function sshadd {
  local SSH_PATH="${HOME}/.ssh"
  local key_name=$1
  if [[ -z "$key_name" ]]; then
    find ~/.ssh -mindepth 1 -type d -printf '%P\n'
  else
    ssh-add "${SSH_PATH}/${key_name}/${key_name}.pem"
  fi
}

## Completions options
zstyle ":completion:*" completer _expand _complete _ignored _approximate
zstyle ":completion:*:match:*" original only
zstyle ":completion:*:approximate:*" max-errors 1 numeric
zstyle ":completion:*" format "${fg_bold[red]}+${fg_bold[white]} %d ${fg_bold[cyan]}-${reset_color}"
zstyle ":completion:*" group-name ''
zstyle ":completion:*" matcher-list '' 'r:|[._-]=* r:|=*' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
zstyle ":completion:*" menu select
zstyle ":completion:*" rehash true
zstyle ":completion:*" squeeze-slashes true
zstyle ":completion:*:functions" ignore-patterns "_*"
zstyle ":completion:*:cd:*" ignore-parents parent pwd
zstyle :compinstall filename "${HOME}/.zshrc"

## History
HISTFILE="${HOME}/.histfile"
HISTSIZE=1000
SAVEHIST=1000
setopt append_history share_history extended_history histignorealldups histignorespace

## Key bindings
bindkey -e
[[ -f "$ZSH_KEYBIND_PATH" ]] && source "$ZSH_KEYBIND_PATH"

## Misc. options
setopt autocd auto_pushd pushd_ignore_dups
setopt longlistjobs
setopt nobeep
setopt noglobdots
setopt notify

## Aliases
[[ -f "$ALIAS_PATH" ]] && source "$ALIAS_PATH"
[[ -f "$ENV_ALIAS_PATH" ]] && source "$ENV_ALIAS_PATH"
[[ -f "$ZSH_ALIAS_PATH" ]] && source "$ZSH_ALIAS_PATH"

## Plugins
[[ -f "${ZSH_AUTOSUGGESTIONS_DIR}/zsh-autosuggestions.zsh" ]] && source "${ZSH_AUTOSUGGESTIONS_DIR}/zsh-autosuggestions.zsh"
[[ -f "${ZSH_SYNTAX_HIGHLIGHTING_DIR}/zsh-syntax-highlighting.zsh" ]] && source "${ZSH_SYNTAX_HIGHLIGHTING_DIR}/zsh-syntax-highlighting.zsh"
[[ -f "${ZSH_YARN_AUTOCOMPLETIONS_DIR}/yarn-autocompletions.plugin.zsh" ]] && source "${ZSH_YARN_AUTOCOMPLETIONS_DIR}/yarn-autocompletions.plugin.zsh"

[[ -o interactive ]] && cowsay -f "$(cowsay -l | grep -v 'Cow files' | tr ' ' '\n' | shuf -n1)" "$(fortune)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
