# Add ~/bin to my path
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Support Homebrew on macOS and Linux
BREW_PATH=""
if [ -x /opt/homebrew/bin/brew ]; then
	BREW_PATH="/opt/homebrew/bin/brew"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
	BREW_PATH="/home/linuxbrew/.linuxbrew/bin/brew"
fi

if [ -x "$BREW_PATH" ]; then

	# Load Homebrew
	eval "$($BREW_PATH shellenv)"

	# Enable completions
	FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
	autoload -Uz compinit
	compinit

	# Set prompt to show current directory and git branch
	# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
	if [ -r "$(brew --prefix)/etc/bash_completion.d/git-prompt.sh" ]; then
		source "$(brew --prefix)/etc/bash_completion.d/git-prompt.sh"
		GIT_PS1_SHOWDIRTYSTATE=1
		precmd() {
			__git_ps1 "%F{244}%1~" " %#%f "
		}
	else
		echo ".zshrc: Could not load git prompt."
	fi

	# Load z
	if [ -r "$(brew --prefix)/etc/profile.d/z.sh" ]; then
		source "$(brew --prefix)/etc/profile.d/z.sh"
	else
		echo ".zshrc: Could not load z."
	fi

else

	echo ".zshrc: Could not execute brew."

fi

# Load fzf
if which fzf > /dev/null 2>&1; then
	eval "$(fzf --zsh)"
fi

# Load fnm
if which fnm > /dev/null 2>&1; then
	eval "$(fnm env --use-on-cd --shell zsh --version-file-strategy=recursive)"
fi

# Load pyenv
if which pyenv > /dev/null 2>&1; then
	eval "$(pyenv init -)"
else
	echo ".zshrc: Could not load pyenv."
fi

# Load rbenv
if which rbenv > /dev/null 2>&1; then
	eval "$(rbenv init - --no-rehash zsh)"
else
	echo ".zshrc: Could not load rbenv."
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
export FZF_DEFAULT_COMMAND="rg --files"
