" init.vim

" +----------------------------------------------------------------------------+
" | Plugins
" +----------------------------------------------------------------------------+

" dein.vim : plugin manager
if &compatible
	set nocompatible
endif

" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
	call dein#begin('~/.cache/dein')

	call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
	call dein#add('Shougo/deoplete.nvim')
	if !has('nvim')
		call dein#add('roxma/nvim-yarp')
		call dein#add('roxma/vim-hug-neovim-rpc')
	endif

	" colorscheme
	call dein#add('w0ng/vim-hybrid')

	" statusbar
	call dein#add('vim-airline/vim-airline')
	call dein#add('vim-airline/vim-airline-themes')

	" git
	call dein#add('tpope/vim-fugitive')
	call dein#add('airblade/vim-gitgutter')

	" fzf
	set runtimepath+=~/.fzf
	call dein#add('junegunn/fzf.vim')

	" tmux
	call dein#add('christoomey/vim-tmux-navigator')
	call dein#add('edkolev/tmuxline.vim')

	" window movement
	call dein#add('wesQ3/vim-windowswap')

	" tags
	call dein#add('ludovicchabant/vim-gutentags')
	call dein#add('skywind3000/gutentags_plus')

	" quality of life
	call dein#add('tpope/vim-commentary')
	call dein#add('tpope/vim-eunuch')
	call dein#add('tpope/vim-surround')
	call dein#add('tpope/vim-repeat')

	call dein#end()
	call dein#save_state()
endif

filetype plugin indent on
syntax enable

" Install new plugins on startup
if dein#check_install()
	call dein#install()
endif

" +----------------------------------------------------------------------------+
" | Plugin Options
" +----------------------------------------------------------------------------+

" deoplete
let g:deoplete#enable_at_startup = 1

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" windowsnap
let g:windowswap_map_keys = 0 "prevent default bindings

" gutentags
let g:gutentags_modules = ['ctags', 'gtags_cscope']
let g:gutentags_project_root = ['.root']
let g:gutentags_cache_dir = '~/.cache/tags'
let g:gutentags_plus_switch = 1

" +----------------------------------------------------------------------------+
" | Remaps
" +----------------------------------------------------------------------------+

" Make Vim recognize XTerm escape sequences for Page and Arrow
" keys combined with modifiers such as Shift, Control, and Alt.
" See http://www.reddit.com/r/vim/comments/1a29vk/_/c8tze8p
if &term =~ '^screen'
	" Page keys http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
	execute "set t_kP=\e[5;*~"
	execute "set t_kN=\e[6;*~"

	" Arrow keys http://unix.stackexchange.com/a/34723
	execute "set <xUp>=\e[1;*A"
	execute "set <xDown>=\e[1;*B"
	execute "set <xRight>=\e[1;*C"
	execute "set <xLeft>=\e[1;*D"
endif

" Set leader key
let mapleader = " "

" Clear hlsearch
nnoremap <C-c> :nohlsearch<CR>

" Windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <Leader>s <C-w>s
nnoremap <Leader>v <C-w>v
nnoremap <Leader>= <C-w>=
nnoremap <leader>w :call WindowSwap#EasyWindowSwap()<CR>

nnoremap <Leader>n :bnext<CR>
nnoremap <Leader>p :bprevious<CR>
nnoremap <Leader>l :buffer #<CR>
nnoremap <Leader>d :bdelete<CR>

" fugitive
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>gs :Gstatus<CR>

" fzf
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>r :Rg<CR>
nnoremap <Leader>t :Tags<CR>

" tab completion
inoremap <expr> <tab> pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

" +----------------------------------------------------------------------------+
" | Appearance
" +----------------------------------------------------------------------------+

" Colorscheme
colorscheme hybrid

" Set primary text to white
highlight Normal ctermfg=White

" Set background to terminal
highlight Normal ctermbg=None

" Set special char to blue
highlight SpecialChar ctermfg=167 guifg=#cc6666

" vim-airline theme
let g:airline_theme = 'wombat'

" Show cursor line
set cursorline

" Line numbers
set number

" 80 char limit
set colorcolumn=81

" Tab width
set shiftwidth=4
set tabstop=4

" +----------------------------------------------------------------------------+
" | Miscellaneous
" +----------------------------------------------------------------------------+

" Enable mouse support
set mouse=a

" Allow modified buffers to be hidden
set hidden

" Split behavior
set splitright
set splitbelow

" Search options
nmap / /\v
nmap ? ?\v

" Highlight whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Copy/paste from the system clipboard
set clipboard=unnamedplus
