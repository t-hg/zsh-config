# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
# Write to the history file immediately,
# not when the shell exits
setopt INC_APPEND_HISTORY

# Load color definitions
autoload -Uz colors && colors

# Prompt show current folder
PROMPT="%{$fg_bold[blue]%}%1~"

# Prompt show Git status
autoload -Uz vcs_info
setopt prompt_subst
PROMPT="$PROMPT%{$fg_bold[magenta]%}\${vcs_info_msg_0_}"
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' (%b%u%c)'
zstyle ':vcs_info:git:*' actionformats ' (%b|%a%u%c)'
precmd_functions+=(vcs_info)

# Prompt show '%' for normal user, '#' for root
if [[ "$EUID" == "0" ]]; then
	PROMPT="$PROMPT %{$fg_bold[red]%}%#"
else
	PROMPT="$PROMPT %{$fg_bold[green]%}%#"
fi
PROMPT="${PROMPT} %{$reset_color%}"

# Prompt elapsed time begin counting
function prompt_elapsed_time_start() {
	start=$(date +%s)
}
preexec_functions+=(prompt_elapsed_time_start)

# Prompt elapsed time stop counting, show and reset
function prompt_elapsed_time_stop_reset() {
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
precmd_functions+=(prompt_elapsed_time_stop_reset)

# Enable vi mode
setopt vi
KEYTIMEOUT=1
bindkey -v
bindkey '^R' history-incremental-search-backward 
bindkey '^H' backward-delete-char
bindkey '^?' backward-delete-char

# Cursor color
echo -ne "\e]12;gray\a"

# Cursor shape
# Normal mode: block
# Insert mode: beam
function zle-keymap-select () {
	if [[ $KEYMAP == vicmd ]]; then
		# the command mode for vi
		echo -ne "\e[2 q"
	else
		# the insert mode for vi
		echo -ne "\e[5 q"
	fi
}
precmd_functions+=(zle-keymap-select)
zle -N zle-keymap-select

# Showing current command in the title can 
# help when similar commands with different options
# are running.
function use_last_command_as_title() {
	is_emacs=false
	if [[ "$TERM" == "dumb" ]] || [[ "$TERM" == "eterm-color" ]]; then
		is_emacs=true
	fi
	if [[ "$is_emacs" == "false" ]]; then
		lastcmd="$1"
		echo -ne "\e]2;$lastcmd\a\e]1;$lastcmd\a"
	fi
}
preexec_functions+=(use_last_command_as_title)

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

# Source custom files
[[ -d "$HOME/.zshrc.d" ]] && for file in $HOME/.zshrc.d/*; do
	source "$file"
done
