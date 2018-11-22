#!/bin/bash
#
# Installs dependencies for dotfiles

read -p "Install packages? [y|n]: " result
if [ "$result" == "y" -o "$result" == "Y" ]; then
	# Install vim with system clipboard capability
	echo "Installing vim..."
	sudo apt-get install -y vim-gnome

	# Install tmux
	echo "Installing tmux..."
	sudo apt-get install -y tmux

	# xclip (for tmux vi-copy)
	echo "Installing xclip..."
	sudo apt-get install -y xclip

	# Tagbar
	echo "Installing exuberant-ctags..."
	sudo apt-get install -y exuberant-ctags

elif [ "$result" == "n" -o "$result" == "N" ]; then
	echo "Skipped installing packages"
else
	echo "ERR: Unknown option \"$result\""
	exit 1
fi

# Install Vundle
echo "Checking Vundle install..."
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# Update vimrc
ln -frs vimrc ~/.vimrc

# Update tmux.conf
ln -frs tmux.conf ~/.tmux.conf

# Update vimrc plugins
echo "Updating vim plugins..."
vim +PluginClean +PluginInstall +qall

# Append bashrc to ~/.bashrc
echo "Updating bashrc..."
AUTO_HEADER="##### AUTO BASHRC START #####"
AUTO_FOOTER="##### AUTO BASHRC END #####"
if [ -e ~/.bashrc ]; then
	sed -i "/^${AUTO_HEADER}\$/,/^${AUTO_FOOTER}\$/d" ~/.bashrc
fi
echo $AUTO_HEADER >> ~/.bashrc
cat bashrc >> ~/.bashrc
echo $AUTO_FOOTER >> ~/.bashrc

# Tmuxline
echo "Updating Tmuxline..."
TMUXLINE_SNAPFILE="~/.tmuxline.snap"
tmux new 'vim +"TmuxlineSnapshot! $TMUXLINE_SNAPFILE" +qall'

# Powerline fonts
read -p "Install powerline fonts? [y|n]: " result
if [ "$result" == "y" -o "$result" == "Y" ]; then
	pushd ~/.vim/bundle/fonts
		./install.sh
	popd
	echo "Installed powerline fonts"
elif [ "$result" == "n" -o "$result" == "N" ]; then
	echo "Skipped installing powerline fonts"
else
	echo "ERR: Unknown option \"$result\""
	exit 1
fi

# fzf
if [ ! -d "$HOME/.fzf" ]; then
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
else
	pushd $HOME/.fzf
	git pull
	yes | ./install
	popd
fi
