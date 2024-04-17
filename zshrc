# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# Load color definitions
autoload -Uz colors && colors

# Prompt configuration
PROMPT="%{$fg_bold[blue]%}%1~"
autoload -Uz vcs_info
setopt prompt_subst
PROMPT="$PROMPT%{$fg_bold[magenta]%}\${vcs_info_msg_0_}"
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' (%b%u%c)'
zstyle ':vcs_info:git:*' actionformats ' (%b|%a%u%c)'
if [[ "$EUID" == "0" ]]; then
	PROMPT="$PROMPT %{$fg_bold[red]%}%#"
else
	PROMPT="$PROMPT %{$fg_bold[green]%}%#"
fi
PROMPT="${PROMPT} %{$reset_color%}"

is_emacs=false
if [[ "$TERM" == "dumb" ]] || [[ "$TERM" == "eterm-color" ]]; then
    is_emacs=true
fi


function preexec() {
	# Set start to 
	# calculate elapesed time
	start=$(date +%s)
}

function precmd() {
	# Update git prompt
	vcs_info

	# Calculate elapsed time
	PROMPT=$(echo -n "$PROMPT" | sed -r 's/took [^ ]+ //g')
	if [[ "$start" != "" ]]; then
		end=$(date +%s)
		elapsed=$((end - start))
		start=
		if [[ $elapsed -eq 0 ]]; then
    		return 0
		elif [[ $elapsed -gt 3600 ]]; then
    		formatted=$(date -d@${elapsed} -u +%-Hh%-Mm%-Ss)
		elif [[ $elapsed -gt 60 ]]; then
    		formatted=$(date -d@${elapsed} -u +%-Mm%-Ss)
		else
    		formatted=${elapsed}s
		fi
		PROMPT="took %{$fg_bold[yellow]%}$formatted%{$reset_color%} $PROMPT"
	fi
	
}

# Colored output
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

# Fuzzy finder (Ctrl-r)
[[ -n "$FZF_KEY_BINDINGS" ]] && source "$FZF_KEY_BINDINGS"

# Zsh completion
autoload -U compinit && compinit
unsetopt automenu

# Fuzzy tab completion
zstyle ':completion:*' matcher-list \
	'm:{[:lower:]}={[:upper:]}' \
	'+r:|[._-]=* r:|=*' \
	'+l:|=*'

# Enable vi mode
#bindkey -v
#bindkey ^R history-incremental-search-backward 

# Source custom files
[[ -d "$HOME/.zshrc.d" ]] && for file in $HOME/.zshrc.d/*; do
	source "$file"
done
