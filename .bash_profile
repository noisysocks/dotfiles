# Configure $PATH
export PATH="/usr/local/sbin:$PATH"

# Increase how big .bash_history can grow
export HISTSIZE=100000
export HISTFILESIZE=100000

# Show git status in my prompt
GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[$(tput setaf 7)\]\W$(__git_ps1)$ \[$(tput sgr0)\]'

# Enable bash-completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# Enable z
[ -f /usr/local/etc/profile.d/z.sh ] && . /usr/local/etc/profile.d/z.sh

# Load in a seperate config file for sensitive information
[ -f ~/.private_bash_profile ] && . ~/.private_bash_profile
