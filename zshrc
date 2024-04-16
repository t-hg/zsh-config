ANTIGEN_LOG="$HOME/.antigen/antigen.log"
source /usr/share/zsh-antigen/antigen.zsh

# Bundles from oh-my-zsh repo
antigen use oh-my-zsh
antigen bundle git

# Bundles from other locations
antigen bundle jeffreytse/zsh-vi-mode
antigen bundle zsh-users/zsh-autosuggestions

# Load the theme.
antigen theme simple

# Tell Antigen that you're done.
antigen apply

# Called after zsh-vi-mode 
# has been initialized
function zvm_after_init() {
   # Fuzzy finder
	if [ -z "$FZF_KEY_BINDINGS" ]; then
    	if [ -f /usr/share/fzf/key-bindings.zsh ]; then
        	FZF_KEY_BINDINGS=/usr/share/fzf/key-bindings.zsh
    	fi
	fi
	if [ -n "$FZF_KEY_BINDINGS" ]; then
    	source "$FZF_KEY_BINDINGS"
	fi
}
