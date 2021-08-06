#!/bin/sh

# [git]
# install git hooks

install -dv ~/.git/hooks
install -bCSv git/hooks/* ~/.git/hooks

# install gitignore
install -bCSv gitignore ~/.gitignore

# install gitconfig
sh gitconfig

# [vim]

install -dv ~/.vim/doc
install -bCSv vim/doc/* ~/.vim/doc
install -dv ~/.vim/plugin
install -bCSv vim/plugin/* ~/.vim/plugin
install -dv ~/.vim/templates
install -bCSv vim/templates/* ~/.vim/templates
install -dv ~/.vim/pythonx/maxprod
install -bCSv vim/pythonx/maxprod/* ~/.vim/pythonx/maxprod

install -bCSv vimrc ~/.vimrc

# [bash]
install -bCSv bashrc ~/.bashrc

# [zsh]
install -bCSv zshrc ~/.zshrc

# [pythonrc]
install -bCSv pythonrc ~/.pythonrc
