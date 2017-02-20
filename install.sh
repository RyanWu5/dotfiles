#!/bin/bash
#
# Installs dependencies for dotfiles

# Update configuration file with user prompts
update_file () {
	local dst=$1
	local src=$2
	local result

	echo "Updating \"$dst\"..."

	if [ ! -e $src ]; then
		echo "ERR: Cannot find \"$src\""
		exit 1
	fi

	if [ ! -e $dst  ]; then
		echo "Creating new file at $dst"
		cp $src $dst
		echo "Copied \"$src\" to \"$dst\""
	else
		if [ -z "$(diff $src $dst)" ]; then
			echo "\"$src\" and \"$dst\" are identical"
		else
			echo "\"$src\" and \"$dst\" differ"
			if [ "$(ls -t $src $dst | head -n1)" == "$src" ]; then
				read -p "Do you want to update \"$dst\" with a newer \"$src\"? [y|n]: " result
			else
				read -p "WARN: Do you want to replace \"$dst\" with an older \"$src\"? [y|n]: " result
			fi

			if [ "$result" == "y" -o "$result" == "Y" ]; then
				cp $src $dst
				echo "Copied \"$src\" to \"$dst\""
			elif [ "$result" == "n" -o "$result" == "N" ]; then
				echo "Skipping \"$dst\" update"
			else
				echo "ERR: Unknown option \"$result\""
				exit 1
			fi
		fi
	fi

	echo "Done"
}

# Install vim with system clipboard capability
echo "Installing vim..."
apt-get install -y vim-gnome

# Install tmux
echo "Installing tmux..."
apt-get install -y tmux

# Install Vundle
echo "Checking Vundle install..."
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# Update vimrc
update_file ~/.vimrc vimrc

# Update tmux.conf
update_file ~/.tmux.conf tmux.conf

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

# xclip (for tmux vi-copy)
echo "Installing xclip..."
apt-get install -y xclip

# Tagbar
echo "Installing exuberant-ctags..."
apt-get install -y exuberant-ctags

# Configure YouCompleteMe
echo "Installing Clang and CMake..."
apt-get install -y build-essential cmake
apt-get install -y python-dev python3-dev
read -p "Compile Clang completer for YouCompleteMe? [y|n]: " result
if [ "$result" == "y" -o "$result" == "Y" ]; then
	pushd ~/.vim/bundle/youcompleteme
	./install.py --clang-completer
	popd
	cp $src $dst
	echo "Compiled Clang completer"
elif [ "$result" == "n" -o "$result" == "N" ]; then
	echo "Skipped compiling Clang completer"
else
	echo "ERR: Unknown option \"$result\""
	exit 1
fi
