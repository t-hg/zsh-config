ANTIGEN_LOG="$HOME/.antigen/antigen.log"
source /usr/share/zsh-antigen/antigen.zsh

# Bundles from oh-my-zsh repo
antigen use oh-my-zsh
antigen bundle git

# Bundles from other locations
antigen bundle jeffreytse/zsh-vi-mode

# Load the theme.
antigen theme simple

# Tell Antigen that you're done.
antigen apply
