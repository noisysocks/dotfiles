# Configure $PATH
export PATH="~/bin:/usr/local/sbin:$PATH"

# Increase how big .bash_history can grow
export HISTSIZE=100000
export HISTFILESIZE=100000

# Show git status in my prompt
GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[$(tput setaf 7)\]\W$(__git_ps1)$ \[$(tput sgr0)\]'

# Configure GPG
export GPG_TTY=$(tty)

# Enable bash-completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# Enable z
[ -f /usr/local/etc/profile.d/z.sh ] && . /usr/local/etc/profile.d/z.sh

# Enable nvm
export NVM_DIR=~/.nvm
[ -f /usr/local/opt/nvm/nvm.sh ] && . /usr/local/opt/nvm/nvm.sh
[ -f "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Load in a seperate config file for sensitive information
[ -f ~/.private_bash_profile ] && . ~/.private_bash_profile
