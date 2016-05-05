#!/bin/bash
#
# Installs dependencies for vim

# Powerline fonts
pushd ~/.vim/bundle/fonts
	./install.sh
popd

# YouCompleteMe
apt-get install build-essential cmake python-dev python3-dev 
pushd ~/.vim/bundle/youcompleteme
	./install.py --clang-completer
popd

# Tagbar
apt-get install exuberant-ctags
