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

" The NERD Tree: file navigation
Plugin 'scrooloose/nerdtree'

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

" buf-explorer
let g:bufExplorerDisableDefaultKeyMapping=1

" +------------+
" | Key Remaps |
" +------------+

" Set leader key
let mapleader = " "

" Clear hlsearch
nnoremap <C-c> :nohlsearch<CR>

" Window navigation
nnoremap <Tab> <C-w>w
nnoremap <C-down> :res -1<CR>
nnoremap <C-up> :res +1<CR>
nnoremap <C-left> :vertical resize -1<CR>
nnoremap <C-right> :vertical resize +1<CR>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Buffer movement
nnoremap <Leader>] :bnext<CR>
nnoremap <Leader>[ :bprevious<CR>
nnoremap <Leader>1 :buffer 1<CR>
nnoremap <Leader>2 :buffer 2<CR>
nnoremap <Leader>3 :buffer 3<CR>
nnoremap <Leader>4 :buffer 4<CR>
nnoremap <Leader>5 :buffer 5<CR>
nnoremap <Leader>6 :buffer 6<CR>
nnoremap <Leader>7 :buffer 7<CR>
nnoremap <Leader>8 :buffer 8<CR>
nnoremap <Leader>9 :buffer 9<CR>

" bufexplorer
nnoremap <Leader>e :BufExplorer<CR>
nnoremap <Leader>s :split<CR>:BufExplorer<CR>
nnoremap <Leader>v :vsplit<CR>:BufExplorer<CR>

" NERD Commenter
map <Leader>c <plug>NERDComComment
map <Leader>u <plug>NERDComUncommentLine

" NERD Tree
map <Leader>n :NERDTreeToggle<CR>

" Toggle tag bar
nnoremap <leader>t :TagbarToggle<CR>

" +---------------+
" | Miscellaneous |
" +---------------+

" Syntax highlighting
syntax on

" Allow modified buffers to be hidden
set hidden

" Split behavior
set splitright
set splitbelow

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
