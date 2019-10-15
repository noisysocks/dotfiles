# Configure path
export PATH="~/bin:/usr/local/sbin:$PATH"

# Enable zsh completions
autoload -Uz compinit && compinit

# Configure prompt
[ -f /usr/local/etc/bash_completion.d/git-prompt.sh ] && . /usr/local/etc/bash_completion.d/git-prompt.sh
setopt PROMPT_SUBST
GIT_PS1_SHOWDIRTYSTATE=1
export PS1='%F{244}%1~$(__git_ps1) %#%f '

# Enable z
[ -f /usr/local/etc/profile.d/z.sh ] && . /usr/local/etc/profile.d/z.sh

# Enable nvm
export NVM_DIR=~/.nvm
[ -f /usr/local/opt/nvm/nvm.sh ] && . /usr/local/opt/nvm/nvm.sh
[ -f /usr/local/opt/nvm/etc/bash_completion ] && . /usr/local/opt/nvm/etc/bash_completion
