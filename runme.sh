#/bin/bash

DOTFILES_ROOT="$(dirname $(realpath $0))"

################################################################################
# Logging
################################################################################

NOCOLOR='\033[0m'
LIGHTRED='\033[1;31m'
YELLOW='\033[1;33m'
LIGHTCYAN='\033[1;36m'

log_err() {
	echo -e "${LIGHTRED}[-] ${@}${NOCOLOR}"
}

log_wrn() {
	echo -e "${YELLOW}[!] ${@}${NOCOLOR}"
}

log_inf() {
	echo -e "${LIGHTCYAN}[*] ${@}${NOCOLOR}"
}

prompt() {
	echo -ne "${YELLOW}[!] ${@} [y/n]: ${NOCOLOR}"
	read -n 1 -r choice
	echo
	case "$choice" in
		y|Y)
			return 1
			;;
		n|N)
			return 0
			;;
		*)
			log_err "invalid option: $choice"
			return -1
			;;
	esac
}

################################################################################
# Funcs
################################################################################

APT_PACKAGES="neovim tmux ripgrep git xclip exuberant-ctags global clang python3-pip fonts-powerline"
PIP3_PACKAGES="jedi"

BASHRC_HEADER="##### DOTFILES HDR #####"
BASHRC_FOOTER="##### DOTFILES FTR #####"
DOTFILES_PLUGIN_MARKER="__DOTFILES_ROOT__"

check_deps() {
	res=0
	for dep in $@; do
		if ! which "$dep" > /dev/null; then
			log_err "missing dependency: $dep"
			res=1
		fi
	done
	return $res
}

install_from_internet() {
	if ! check_deps curl; then
		log_err "exiting"
		return
	fi

	# packages
	log_inf "installing apt dependencies"
	sudo apt install -y $APT_PACKAGES

	log_inf "installing pip3 dependencies"
	pip3 install --user $PIP3_PACKAGES --upgrade

	# vim plug
	curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	install_dotfiles
}

install_from_local() {
	log_inf "installing from local path: $DOTFILES_ROOT"

	# vim plug
	mkdir -p $HOME/.local/share/nvim/site/autoload
	cp $DOTFILES_ROOT/plugins/plug.vim \
		$HOME/.local/share/nvim/site/autoload/plug.vim

	sed -i "s@^Plug[ \t]*'$DOTFILES_PLUGIN_MARKER@Plug 'file://$DOTFILES_ROOT@" \
		$DOTFILES_ROOT/src/init.vim

	install_dotfiles

	log_wrn "install dependencies:\nsudo apt install $APT_PACKAGES && pip3 install --user $PIP3_PACKAGES --upgrade"
}

install_dotfiles() {
	# vim
	log_inf "installing init.vim"
	mkdir -p $HOME/.config/nvim
	ln -sf $DOTFILES_ROOT/src/init.vim $HOME/.config/nvim/init.vim

	# tmux
	log_inf "installing tmux.conf"
	ln -sf $DOTFILES_ROOT/src/tmux.conf $HOME/.tmux.conf

	# bash
	log_inf "installing bashrc"
	if [ -f $HOME/.bashrc ]; then
		sed -i "/^${BASHRC_HEADER}\$/,/^${BASHRC_FOOTER}\$/d" $HOME/.bashrc
	fi
	echo "$BASHRC_HEADER"          >> $HOME/.bashrc
	cat  $DOTFILES_ROOT/src/bashrc >> $HOME/.bashrc
	echo "$BASHRC_FOOTER"          >> $HOME/.bashrc

	# Install plugins
	TMUXLINE_SNAPFILE="~/.tmuxline.snap"
	tmux new 'vim +PlugInstall +"TmuxlineSnapshot! $TMUXLINE_SNAPFILE" +qall'

}

make_local_dotfiles() {
	if ! check_deps curl git; then
		log_err "exiting"
		return
	fi

	# Validate path
	local path="$1"
	log_inf "making local installation at path: $path"
	if [ -e "$path" ]; then
		prompt "path already exists, remove?"
		if [ $? -ne 1 ]; then
			log_err "exiting"
			return
		fi
		rm -rf "$path"
	fi

	mkdir -p "$path"

	# Copy source files to path
	log_inf "copying source files to path: $path"
	cp -r $DOTFILES_ROOT/src "$path"
	cp "$0" "$path"

	# Pull down plugins
	mkdir "$path/plugins"

	curl -fLo "$path/plugins/plug.vim" \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	while read line; do
		log_inf "Processing plugin: $line"
		echo $line
		local src="$(echo "$line" | sed "s/^Plug[ \t]*'\([^']*\)'.*$/\1/")"
		# TODO: Handle other valid plugin forms
		local dst="$DOTFILES_PLUGIN_MARKER/plugins/$(basename $src)"
		git -C "$path/plugins" clone "https://github.com/$src.git"
		sed -i "s@^Plug[ \t]*'$src'@Plug '$dst'@" "$path/src/init.vim"
	done <<< $(grep "^Plug[ \t]*'[^']*'" "$path/src/init.vim")
}

################################################################################
# Main
################################################################################

usage() {
	log_inf "dotfiles.sh <-i|-l PATH> [-hx]"
	echo
	log_inf "Required: (exactly one)"
	log_inf " -i        Install dotfiles."
	log_inf " -l PATH   Stage local installation at PATH."
	echo
	log_inf "Optional:"
	log_inf " -h        Print usage."
	log_inf " -x        Enable verbose debugging."
	echo
}

main() {
	local mode=
	local path=
	while getopts ":hil:" opt
	do
		case $opt in
			h)
				usage
				return 0
				;;
			x)
				set -x
				;;
			i)
				mode="install"
				;;
			l)
				mode="local"
				path="$OPTARG"
				;;
			\?)
				log_err "invalid option: $OPTARG"
				;;
			:)
				log_err "invalid option: $OPTARG requires an argument"
				;;
		esac
	done
	shift $((OPTIND -1))

	if [ -z "$mode" ]
	then
		log_err "nothing to do"
		usage
		return 1
	fi

	case $mode in
		install)
			install_from_internet
			;;
		local)
			make_local_dotfiles "$path"
	esac
}

# Check for a plugins directory
if [ -d $DOTFILES_ROOT/plugins ]; then
	install_from_local
else
	main $@
fi
