set nu rnu
set autoindent
set hlsearch
set incsearch
set smartcase
set nocompatible
set noswapfile
set autochdir
set colorcolumn=120
set backspace=2
set grepprg=grep\ -nH\ $*
set cursorline
set ai
set ruler

" Un-healthy hack for getting the exact colorscheme that I want
colorscheme wombat256

" -------- Bundle Configuration section --------------------
" Set vundle package manager
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" Include Bundles
Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-fugitive'
Bundle 'sjl/gundo.vim'
Bundle 'godlygeek/tabular'
Bundle 'xolox/vim-session'
Bundle 'xolox/vim-misc'
Bundle 'vim-scripts/Tagbar'
Bundle 'machakann/vim-highlightedyank'
Bundle 'flazz/vim-colorschemes'

" Gundo plugin configuration
set undodir=~/.vim/tmp/undo//
set undofile
set history=100
set undolevels=100

" Vim-session management settings
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "yes"

" Key mappings
map <silent> <F4> :NERDTreeToggle<CR>
map! <silent> <F4> <ESC>:NERDTreeToggle<CR>

map <silent> <F2> :GundoToggle<CR>
map! <silent> <F-2> <ESC>:GundoToggle<CR>

" Tagbar configuration
nnoremap <silent> <F7> :Tagbar<CR>

" Adding git custom command in here
cnoreabbrev gs Gstatus
cnoreabbrev gc Gcommit
cnoreabbrev gp Gpush
cnoreabbrev gl Gpull
cnoreabbrev gw Gwrite

" Putting the OpenSession command to an alias - too much hassle to type this
" big a command
cnoreabbrev os OpenSession

map H ^
map L $

set listchars=tab:>~,nbsp:_,trail:.,eol:$,extends:>,precedes:<
noremap <F6> :set list!<CR>

xnoremap < <gv
xnoremap > >gv

inoremap ^H <BS>

if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    "setglobal bomb
    set fileencodings=ucs-bom,utf-8,latin1
endif

nnoremap <silent> <F8> :sh<CR>

set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1
set tabpagemax=1000
set laststatus=2

" Cool tab completion stuff
set wildmenu
set wildmode=list:longest,full

" Enable mouse support in console
set mouse=a

" Ignoring case is a fun trick
set ignorecase

" And so is Artificial Intellegence!
set smartcase

" Need to set up the clipboard
set clipboard=unnamed
let g:clipbrdDefaultRed = '+'

syntax enable
filetype plugin indent on

map H ^
map L $
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l
map <F8> :sh<CR>
map <F5> :redraw!<CR>

" Make, make clean and the like
let &makeprg = 'if [ -f Makefile ]; then make -C %:p:h $*; else make -C %:p:h/.. $*; fi'
nnoremap <leader>m :silent make!\|redraw!\|cw<CR>

" Setting the color column for specific file types
augroup any
        autocmd FileType * set tabstop=2 colorcolumn=200 shiftwidth=2 nocursorcolumn noexpandtab textwidth=199
augroup END

augroup cc
        autocmd BufRead,BufNewFile *.h,*.c set filetype=c
        autocmd FileType c set colorcolumn=80 tabstop=8 shiftwidth=8 nocursorcolumn noexpandtab textwidth=79
augroup END

augroup cp
        autocmd BufRead,BufNewFile *.hpp,*.cpp set filetype=cpp
        autocmd FileType cpp set colorcolumn=120 tabstop=2 shiftwidth=2 nocursorcolumn noexpandtab textwidth=119
augroup END

augroup python
        autocmd BufRead,BufNewFile *.py set filetype=python
        autocmd FileType python set colorcolumn=80 tabstop=4 shiftwidth=4 nocursorcolumn noexpandtab textwidth=79
augroup END

augroup go
        autocmd BufRead,BufNewFile *.go set filetype=go
        autocmd FileType go set colorcolumn=80 tabstop=8 shiftwidth=8 nocursorcolumn noexpandtab textwidth=79
augroup END

augroup ruby
        autocmd BufRead,BufNewFile *.rb set filetype=ruby
        autocmd FileType ruby set colorcolumn=80 tabstop=8 shiftwidth=8 nocursorcolumn noexpandtab textwidth=79
augroup END

augroup tex
        autocmd BufRead,BufNewFile *.tex set filetype=tex
        autocmd FileType tex set colorcolumn=120 tabstop=8 shiftwidth=8 nocursorcolumn noexpandtab textwidth=119
augroup END

augroup em
        autocmd BufRead,BufNewFile *.ino set filetype=arduino
        autocmd FileType arduino set colorcolumn=80 tabstop=2 shiftwidth=2 nocursorcolumn noexpandtab textwidth=79
augroup END

augroup asm
        autocmd BufRead,BufNewFile *.asm set filetype=asm
        autocmd FileType asm set colorcolumn=120 tabstop=2 shiftwidth=2 cursorcolumn noexpandtab textwidth=119
augroup END

" Adding the time addition shortcut
:nnoremap <F10> "=strftime("%a, %d %b %Y %H:%M:%S %z") . ": "<CR>P
:inoremap <F10> <C-R>=strftime("%a, %d %b %Y %H:%M:%S %z") . ": "<CR>

" Setting up F3 to open a terminal with a vertical split
set splitright " open the split on the right hand side always
nnoremap <silent> <F3> :vertical terminal<CR>

if has("autocmd")
    "au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
    au InsertEnter * silent execute "!echo -ne \e[6 q"
    "au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
    au InsertLeave * silent execute "!echo -ne \e[2 q"
    "au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
    au InsertLeave * silent execute "!echo -ne \e[2 q"
endif

" New mapping for C-b
map <C-d> <C-b>

" Mapping for swapping the panes
map <C-t> <C-w><C-r>

" CtrlP configuration
set runtimepath^=~/.vim/bundle/ctrlp.vim
" For checking files using CtrlP
let g:ctrlp_show_hidden = 1
" Enabling per session caching
let g:ctrlp_use_caching = 1
" Disabling cache clearing on Vim Exit
let g:ctrlp_clear_cache_on_exit = 0
" Setting the directory for saving the caches
let g:ctrlp_cache_dir = $HOME.'/.vim/ctrlp_cache/'
