" .vimrc
" Ryan Wu
"

" +------------+
" | My Plugins |
" +------------+

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" youcompleteme: autocompletion
Plugin 'valloric/youcompleteme'

" Tagbar: source navigation
Plugin 'majutsushi/tagbar'

" The NERD Commenter: code commenting
Plugin 'scrooloose/nerdcommenter'

" vim.fugitive: git integration
Plugin 'tpope/vim-fugitive'

" vim-airline: status bar
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'powerline/fonts'

" vim-bufferline: status bar buffers
Plugin 'bling/vim-bufferline'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" +----------------------+
" | Plugin Customization |
" +----------------------+



" +------------+
" | Key Remaps |
" +------------+

" Set leader key
let mapleader = " "

" Toggle tag bar
nnoremap <leader>t :TagbarToggle<CR>

" Clear hlsearch
nnoremap <c-l> :nohlsearch<CR>

" +---------------+
" | Miscellaneous |
" +---------------+

" Syntax highlighting
syntax on

" Search options
set hlsearch
set incsearch
nnoremap / /\v
nnoremap ? ?\v

" Persistent status bar
set laststatus=2

" Line numbers
set number  

" Tab width
set shiftwidth=4
set tabstop=4

" Copy/paste from the system clipboard
set clipboard=unnamedplus
