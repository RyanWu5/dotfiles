" .vimrc
" Ryan Wu

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

" Tagbar: source navigation
Plugin 'majutsushi/tagbar'

" The NERD Tree: file navigation
Plugin 'scrooloose/nerdtree'

" vim.fugitive: git integration
Plugin 'tpope/vim-fugitive'

" gitgutter: gutter diff
Plugin 'airblade/vim-gitgutter'

" vim.surround: insert surrounding pairs
Plugin 'tpope/vim-surround'

" vim.commentary: code commenting with gc
Plugin 'tpope/vim-commentary'

" vim.eunuch: shell commands
Plugin 'tpope/vim-eunuch'

" vim.repeat: repeat for plugins
Plugin 'tpope/vim-repeat'

" Tabular: tab alignment
Plugin 'godlygeek/tabular'

" vim-airline: status bar
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'powerline/fonts'

" fzf: fuzzy finder
set rtp+=~/.fzf
Plugin 'junegunn/fzf.vim'

" bufexplorer: buffer navigation
Plugin 'jlanzarotta/bufexplorer'

" youcompleteme: autocompletion
Plugin 'valloric/youcompleteme'

" ycm-generator: ycm config files
Plugin 'rdnetto/ycm-generator'

" vim-tmux-navigator: vim-tmux integration
Plugin 'christoomey/vim-tmux-navigator'

" Tmuxline.vim: vim-style tmux status bar
Plugin 'edkolev/tmuxline.vim'

" hybrid: colorscheme
Plugin 'w0ng/vim-hybrid'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" +----------------------+
" | Plugin Customization |
" +----------------------+

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" bufexplorer
let g:bufExplorerDisableDefaultKeyMapping = 1

" YouCompleteMe
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion = 1

" +------------+
" | Key Remaps |
" +------------+

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
nmap <C-c> :nohlsearch<CR>

" Window navigation
nmap <C-j>     <C-w>j
nmap <C-k>     <C-w>k
nmap <C-h>     <C-w>h
nmap <C-l>     <C-w>l
nmap <C-down>  :resize -1<CR>
nmap <C-up>    :resize +1<CR>
nmap <C-left>  :vertical resize -1<CR>
nmap <C-right> :vertical resize +1<CR>
nmap <S-down>  <C-w>J
nmap <S-up>    <C-w>K
nmap <S-left>  <C-w>H
nmap <S-right> <C-w>L
nmap <Leader>= <C-w>=

" Buffer navigation
nmap <Leader>1 :buffer 1<CR>
nmap <Leader>2 :buffer 2<CR>
nmap <Leader>3 :buffer 3<CR>
nmap <Leader>4 :buffer 4<CR>
nmap <Leader>5 :buffer 5<CR>
nmap <Leader>6 :buffer 6<CR>
nmap <Leader>7 :buffer 7<CR>
nmap <Leader>8 :buffer 8<CR>
nmap <Leader>9 :buffer 9<CR>
nmap <Leader>n :bnext<CR>
nmap <Leader>p :bprevious<CR>
nmap <Leader>l :buffer #<CR>

" bufexplorer
nmap <Leader>e :BufExplorer<CR>
nmap <Leader>s :split<CR>:BufExplorer<CR>
nmap <Leader>v :vsplit<CR>:BufExplorer<CR>
nmap <Leader>S :split<CR>
nmap <Leader>V :vsplit<CR>

" NERD Tree
map <Leader>f :NERDTreeToggle<CR>

" Toggle tag bar
nmap <leader>t :TagbarToggle<CR>

" Tabular
nmap <Leader><Tab> :Tabularize /
vmap <Leader><Tab> :Tabularize /

" fugitive
nmap <Leader>gb :Gblame<CR>
nmap <Leader>gd :Gdiff<CR>
nmap <Leader>gl :Glog<CR>
nmap <Leader>gs :Gstatus<CR>

" fzf
nmap <C-p> :FZF<CR>

" YouCompleteMe
nmap <Leader>yc :YcmCompleter GoToDeclaration<CR>
nmap <Leader>yf :YcmCompleter GoToDefinition<CR>
nmap <Leader>yt :YcmCompleter GetType<CR>

" +------------+
" | Appearance |
" +------------+

" Syntax highlighting
syntax enable

" Show cursor line
set cursorline

" Persistent status bar
set laststatus=2

" Line numbers
set number

" Tab width
set shiftwidth=4
set tabstop=4

" Colorscheme
set background=dark
colorscheme hybrid

" Set primary text to white
highlight Normal ctermfg=White

" Set background to black
highlight Normal ctermbg=None

" vim-airline theme
let g:airline_theme = 'wombat'

" +---------------+
" | Miscellaneous |
" +---------------+

" Allow modified buffers to be hidden
set hidden

" Split behavior
set splitright
set splitbelow

" Search options
set hlsearch
set incsearch
nmap / /\v
nmap ? ?\v

" Highlight whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Copy/paste from the system clipboard
set clipboard=unnamedplus

" Set encoding required by YouCompleteMe
set encoding=utf-8
