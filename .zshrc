# Add ~/bin to my path
export PATH="$HOME/bin:$PATH"

if [ -x /opt/homebrew/bin ]; then

	# Load Homebrew
	eval $(/opt/homebrew/bin/brew shellenv)

	# Enable completions
	FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
	autoload -Uz compinit
	compinit

	# Set prompt to show current directory and git branch
	# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
	if [ -r $(brew --prefix)/etc/bash_completion.d/git-prompt.sh ]; then
		source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
		GIT_PS1_SHOWDIRTYSTATE=1
		precmd() {
			__git_ps1 "%F{244}%1~" " %#%f "
		}
	else
		echo '.zshrc: Could not load git prompt.'
	fi

	# Load z
	if [ -r $(brew --prefix)/etc/profile.d/z.sh ]; then
		source $(brew --prefix)/etc/profile.d/z.sh
	else
		echo '.zshrc: Could not load z.'
	fi

	# Enable fzf tab completion and key bindings
	if [ -f $(brew --prefix)/opt/fzf/shell/completion.zsh ] && [[ $- == *i* ]]; then
		source $(brew --prefix)/opt/fzf/shell/completion.zsh
	else
		echo '.zshrc: Could not load fzf completions.'
	fi
	if [ -f $(brew --prefix)/opt/fzf/shell/key-bindings.zsh ]; then
		source $(brew --prefix)/opt/fzf/shell/key-bindings.zsh
	else
		echo '.zshrc: Could not load fzf key bindings.'
	fi

	# Load nvm
	if [ -r $(brew --prefix)/opt/nvm/nvm.sh ]; then
		export NVM_DIR=~/.nvm
		source $(brew --prefix)/opt/nvm/nvm.sh
	else
		echo '.zshrc: Could not load nvm.'
	fi
	if [ -r $(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm ]; then
		source $(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm
	else
		echo '.zshrc: Could not load nvm completions.'
	fi

else

	echo '.zshrc: Could not execute brew.'

fi

# Use nvim as my editor
export EDITOR=nvim
alias vim=nvim

# Make zsh save to .zsh_history immediately
setopt INC_APPEND_HISTORY

# Remove duplicate commands from .zsh_history
setopt HIST_IGNORE_ALL_DUPS

# Increase maximum size of .zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000

# Configure fzf to, by default, only look at the files that rg indexes
export FZF_DEFAULT_COMMAND='rg --files'

# Configure gpg
export GPG_TTY=$(tty)
