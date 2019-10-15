# dotfiles

My various config files. Storing them online makes it slightly easier to move
computer.

❤️

## Installing

```
git clone https://github.com/noisysocks/dotfiles.git
cd dotfiles
git submodule init
git submodule update
ln -s "$PWD/.zshrc" ~/.zshrc
ln -s "$PWD/.vimrc" ~/.vimrc
ln -s "$PWD/.vim" ~/.vim
ln -s "$PWD/.gitconfig" ~/.gitconfig
```

## Updating vim plugins

```
git submodule update --remote --merge
```
