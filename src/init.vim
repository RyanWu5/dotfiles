" init.vim

" +----------------------------------------------------------------------------+
" | Plugins
" +----------------------------------------------------------------------------+

if &compatible
	set nocompatible
endif

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" colorscheme
Plug 'w0ng/vim-hybrid'

" statusbar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.vim/plugged/fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" tmux
Plug 'christoomey/vim-tmux-navigator'
Plug 'edkolev/tmuxline.vim'

" tags
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'

" quality of life
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'

" autocompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neco-syntax'
Plug 'Shougo/deoplete-clangx'
Plug 'deoplete-plugins/deoplete-jedi'

" Initialize plugin system
call plug#end()

" +----------------------------------------------------------------------------+
" | Plugin Options
" +----------------------------------------------------------------------------+

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" gutentags
let g:gutentags_modules = ['ctags', 'gtags_cscope']
let g:gutentags_project_root = ['.root']
let g:gutentags_cache_dir = '~/.cache/tags'
let g:gutentags_plus_switch = 1

" deoplete
let g:deoplete#enable_at_startup = 1
set completeopt-=preview

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
nnoremap <Leader>w <C-w>=

nnoremap <Leader>n :bnext<CR>
nnoremap <Leader>p :bprevious<CR>
nnoremap <Leader>l :buffer #<CR>
nnoremap <Leader>d :bdelete<CR>

" fzf
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>r :Rg<CR>
nnoremap <Leader>t :Tags<CR>

" vim-fugitive
nnoremap <Leader>g :Gdiffsplit<CR>

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

" Drop mode information
set noshowmode

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
