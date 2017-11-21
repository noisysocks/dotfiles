# Enable bash-completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# Show git status in my prompt
GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[$(tput setaf 7)\]\W$(__git_ps1)$ \[$(tput sgr0)\]'

# Load in a seperate config file for sensitive information
[ -f ~/.private_bash_profile ] && source ~/.private_bash_profile
