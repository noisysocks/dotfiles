# Configure PATH to include ~/bin and any paths needed by Homebrew.
export PATH="~/bin:/usr/local/sbin:$PATH"

# Enable zsh completion.
autoload -Uz compinit && compinit

# Set zsh's prompt to show the current directory and the current git branch.
[ -f /usr/local/etc/bash_completion.d/git-prompt.sh ] && . /usr/local/etc/bash_completion.d/git-prompt.sh
setopt PROMPT_SUBST
GIT_PS1_SHOWDIRTYSTATE=1
export PS1='%F{244}%1~$(__git_ps1) %#%f '

# Load z.
[ -f /usr/local/etc/profile.d/z.sh ] && . /usr/local/etc/profile.d/z.sh

# Load nvm.
export NVM_DIR=~/.nvm
[ -f /usr/local/opt/nvm/nvm.sh ] && . /usr/local/opt/nvm/nvm.sh
[ -f /usr/local/opt/nvm/etc/bash_completion ] && . /usr/local/opt/nvm/etc/bash_completion

# Configure fzf to, by default, only look at the files that rg indexes.
export FZF_DEFAULT_COMMAND='rg --files'

# Use nvim as my editor.
export EDITOR=nvim
alias vim=nvim
