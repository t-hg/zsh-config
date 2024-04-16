autoload -U colors && colors
PROMPT="%{$fg_bold[blue]%}%1~"
if [[ "$EUID" == "0" ]]; then
	PROMPT="$PROMPT %{$fg_bold[red]%}#"
else
	PROMPT="$PROMPT %{$fg_bold[green]%}$"
fi
PROMPT="${PROMPT} %{$reset_color%}"
