#!/bin/bash

DOTFILES_ROOT="$(dirname $(realpath $0))"
TMPDIR=

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

################################################################################
# Funcs
################################################################################

#
# utils
#

symlink() {
	local src=$1
	local dst=$2
	local dst_parent=$(dirname $(realpath $dst))

	if [ ! -d $dst_parent ]
	then
		mkdir --parents $dst_parent
	fi

	if [ ! -f $dst ]
	then
		log_inf "creating symlink: $src -> $dst"
		ln --symbolic $src $dst
	fi
}

apt_install() {
	local pkgs_to_install=
	for pkg in $@
	do
		apt-mark showinstall | grep -q "^$pkg$"
		if [ $? -ne 0 ]
		then
			log_inf "installing package: $pkg"
			pkgs_to_install+=" $pkg"
		else
			log_inf "already installed: $pkg"
		fi
	done

	if [ -n "$pkgs_to_install" ]
	then
		sudo apt install --yes $pkgs_to_install
	fi
}

apt_remove() {
	local pkgs_to_remove=
	for pkg in $@
	do
		apt-mark showinstall | grep -q "^$pkg$"
		if [ $? -eq 0 ]
		then
			log_inf "removing package: $pkg"
			pkgs_to_remove+=" $pkg"
		else
			log_inf "not installed: $pkg"
		fi
	done

	if [ -n "$pkgs_to_remove" ]
	then
		sudo apt remove --yes $pkgs_to_remove
	fi
}

#
# bashrc
#

DOTFILES_HEADER="##### DOTFILES HDR #####"
DOTFILES_FOOTER="##### DOTFILES FTR #####"

install_bashrc() {
	log_inf "installing bashrc"

	uninstall_bashrc

	echo "$DOTFILES_HEADER"           >> $HOME/.bashrc
	cat  $DOTFILES_ROOT/bashrc/bashrc >> $HOME/.bashrc
	echo "$DOTFILES_FOOTER"           >> $HOME/.bashrc
}

uninstall_bashrc() {
	log_inf "uninstalling bashrc"

	if [ -f $HOME/.bashrc ]; then
		sed -i "/^${DOTFILES_HEADER}\$/,/^${DOTFILES_FOOTER}\$/d" $HOME/.bashrc
	fi
}

#
# FZF
#

install_fzf() {
	log_inf "installing fzf"

	local fzf_path="$HOME/.fzf"

	if [ ! -d "$fzf_path" ]; then
		log_inf "cloning fzf repo"
		git clone --depth 1 https://github.com/junegunn/fzf.git $fzf_path
	else
		log_inf "updating fzf repo"
		pushd $fzf_path
		git pull
		popd
	fi

	yes | $fzf_path/install
}

uninstall_fzf() {
	log_inf "uninstalling fzf"

	local fzf_path="$HOME/.fzf"

	if [ -d "$fzf_path" ]; then
		$fzf_path/uninstall
		rm -rf $fzf_path
	fi
}

#
# ripgrep
#

install_rg() {
	log_inf "installing rg"

	# TODO: install from repos after updating to 20.04
	# apt_install ripgrep

	local pkg="ripgrep"
	apt-mark showinstall | grep -q "^$pkg$"
	if [ $? -ne 0 ]
	then
		local url="https://github.com/BurntSushi/ripgrep/releases/download/12.0.1/ripgrep_12.0.1_amd64.deb"
		local pkg_path=$(basename $url)
		pushd $TMPDIR
		curl -LO $url
		sudo dpkg -i $pkg_path
		popd
	fi
}

uninstall_rg() {
	log_inf "uninstalling rg"

	# TODO: install from repos after updating to 20.04
	# apt_remove ripgrep

	local pkg="ripgrep"
	apt-mark showinstall | grep -q "^$pkg$"
	if [ $? -eq 0 ]
	then
		sudo dpkg -r $pkg
	fi
}

#
# neovim
#

install_neovim_from_release() {
	local nvim_path="$HOME/bin/nvim"
	if [ ! -d $nvim_path ]
	then
		log_inf "installing neovim from release"
		mkdir -p $nvim_path
		pushd $nvim_path
		local url="https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"
		curl -LO $url
		chmod u+x nvim.appimage
		sudo ln -s $nvim_path/nvim.appimage /usr/bin/vim
		popd
	fi
}

uninstall_neovim_from_release() {
	local nvim_path="$HOME/bin/nvim"
	if [ -d $nvim_path ]
	then
		log_inf "uninstalling neovim from release"
		rm -r $nvim_path
		sudo rm /usr/bin/vim
	fi
}

install_neovim() {
	log_inf "installing neovim"

	# TODO: install from repos after updating to 20.04
	install_neovim_from_release

	# install packages
	log_inf "installing neovim pkgs"
	apt_install curl xclip exuberant-ctags global python3-pip
	pip3 install --user pynvim

	# install init.vim
	log_inf "installing init.vim"
	symlink $DOTFILES_ROOT/nvim/init.vim $HOME/.config/nvim/init.vim

	# install plugin manager
	local dein_path="$HOME/.cache/dein"
	if [ ! -d "$dein_path" ]
	then
		log_inf "installing dein.vim"
		curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > \
			$TMPDIR/installer.sh
		sh $TMPDIR/installer.sh $dein_path
	fi
}

uninstall_neovim() {
	log_inf "uninstalling neovim"

	# TODO: install from repos after updating to 20.04
	uninstall_neovim_from_release

	# uninstall packages
	#apt_remove neovim
	pip3 uninstall --yes pynvim

	# uninstall init.vim
	if [ -f $HOME/.config/nvim/init.vim ]
	then
		log_inf "uninstalling init.vim"
		rm $HOME/.config/nvim/init.vim
	fi

	# uninstall plugin manager
	local dein_path="$HOME/.cache/dein"
	if [ -d "$dein_path" ]
	then
		log_inf "uninstalling dein.vim"
		rm -rf $dein_path
	fi
}

#
# tmux
#

install_tmux() {
	log_inf "installing tmux"

	# install packages
	log_inf "installing tmux pkgs"
	apt_install tmux

	# install init.vim
	log_inf "installing tmux.conf"
	symlink $DOTFILES_ROOT/tmux/tmux.conf $HOME/.tmux.conf

	# update tmuxline
	log_inf "updating tmuxline"
	TMUXLINE_SNAPFILE="~/.tmuxline.snap"
	tmux new 'vim +"TmuxlineSnapshot! $TMUXLINE_SNAPFILE" +qall'
}

uninstall_tmux() {
	log_inf "uninstalling tmux"

	# uninstalling packages
	apt_remove tmux

	# uninstall init.vim
	if [ -f $HOME/.tmux.conf ]
	then
		log_inf "uninstalling tmux.conf"
		rm $HOME/.tmux.conf
	fi

	# uninstall tmuxline
	if [ -f $HOME/.tmuxline.snap ]
	then
		log_inf "uninstalling tmuxline"
		rm $HOME/.tmuxline.snap
	fi
}

################################################################################
# Main
################################################################################

install_all() {
	log_inf "installing all"
	install_bashrc
	install_fzf
	install_rg
	install_neovim
	install_tmux
}

uninstall_all() {
	log_inf "uninstalling all"
	uninstall_bashrc
	uninstall_fzf
	uninstall_rg
	uninstall_neovim
	uninstall_tmux
}

usage() {
	log_inf "dotfiles.sh [-hxiu]"
	log_inf " -h     Print usage"
	log_inf " -x     Enable verbose debugging"
	log_inf " -i     Install dotfiles"
	log_inf " -u     Uninstall dotfiles"
}

main() {
	local mode=
	while getopts ":hiu" opt
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
			u)
				mode="uninstall"
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

	TMPDIR=$(mktemp --directory --tmpdir=./)
	log_inf "created tmpdir: $TMPDIR"

	case $mode in
		install)
			install_all
			;;
		uninstall)
			uninstall_all
			;;
	esac

	rm -rf $TMPDIR
	log_inf "removed tmpdir: $TMPDIR"
}

main $@
