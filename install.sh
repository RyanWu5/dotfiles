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
echo "Installing powerline fonts..."
pushd ~/.vim/bundle/fonts
	./install.sh
popd

# xclip (for tmux vi-copy)
echo "Installing xclip..."
apt-get install xclip

# Tagbar
echo "Installing exuberant-ctags..."
apt-get install exuberant-ctags
