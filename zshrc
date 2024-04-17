# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# Load color definitions
autoload -U colors && colors

# Simple prompt
PROMPT="%{$fg_bold[blue]%}%1~"
if [[ "$EUID" == "0" ]]; then
	PROMPT="$PROMPT %{$fg_bold[red]%}%#"
else
	PROMPT="$PROMPT %{$fg_bold[green]%}%#"
fi
PROMPT="${PROMPT} %{$reset_color%}"
