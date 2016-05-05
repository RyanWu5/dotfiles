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
Plugin 'rdnetto/ycm-generator'

" Tagbar: source navigation
Plugin 'majutsushi/tagbar'

" The NERD Commenter: code commenting
Plugin 'scrooloose/nerdcommenter'

" vim.fugitive: git integration
Plugin 'tpope/vim-fugitive'

" vim-airline: status bar
Plugin 'bling/vim-airline'
"Plugin 'vim-airline/vim-airline-themes'
"Plugin 'powerline/fonts'

" ctrlp: fuzzy finder
Plugin 'kien/ctrlp.vim'

" bufexplorer: buffer navigation
Plugin 'jlanzarotta/bufexplorer'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" +----------------------+
" | Plugin Customization |
" +----------------------+

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" +------------+
" | Key Remaps |
" +------------+

" Set leader key
let mapleader = " "

" Toggle tag bar
nnoremap <leader>t :TagbarToggle<CR>

" Clear hlsearch
nnoremap <c-l> :nohlsearch<CR>

" Split navigation
set splitright
set splitbelow
map <Tab> <C-w>w
map <C-_> :sp<cr>
map <C-\> :vsp<cr>                   
map <C-down> :res -1<cr>
map <C-up> :res +1<cr>
map <C-left> :vertical resize -1<cr>
map <C-right> :vertical resize +1<cr>
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l
map <Down> <C-e>j
map <Up> <C-y>k
map <Leader>] :bn<cr>
map <Leader>[ :bp<cr>
map <Leader>b :bd<cr>

" +---------------+
" | Miscellaneous |
" +---------------+

" Syntax highlighting
syntax on

" Allow modified buffers to be hidden
set hidden

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
