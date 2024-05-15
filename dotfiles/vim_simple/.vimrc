" Basic configurations
set hlsearch
set incsearch
set ruler
set autoindent
set nu
set rnu
set nocompatible
set noswapfile
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1
set tabpagemax=1000
set wildmenu
set wildmode=list:longest,full
set mouse=a
set backspace=2
set ignorecase
set smartcase
set clipboard=unnamed
set nohidden
set listchars=trail:.
set completeopt=longest,menu
set laststatus=2

let g:clipbrdDefaultReg = '+'

filetype plugin indent on
syntax on

" Basic mapping of keys
map H ^
map L $
nnoremap <C-t> <C-w><C-r>

" Setting the colorscheme
colorscheme sorbet

" More navigation mappings
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Automatically cd into the directory that the file is in
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" This shows what you are typing as a command.  I love this!
set showcmd

" Highlighting
highlight MatchParen ctermbg=4

" Setting up the statusline
set statusline=%t%m%r%h%w\ %=[%l,%c%V]\ [%p%%]
noremap <F6> :set list!<CR>

" Setting the color column for specific file types
augroup any
        autocmd FileType * set tabstop=2 colorcolumn=200 shiftwidth=2 noexpandtab textwidth=199
augroup END

augroup cc
        autocmd BufRead,BufNewFile *.h,*.c set filetype=c
        autocmd FileType c set colorcolumn=80 tabstop=8 shiftwidth=8 noexpandtab nocursorcolumn textwidth=79
augroup END

augroup cp
        autocmd BufRead,BufNewFile *.hpp,*.cpp set filetype=cpp
        autocmd FileType cpp set colorcolumn=120 tabstop=2 shiftwidth=2 noexpandtab nocursorcolumn textwidth=119
augroup END

augroup python
        autocmd BufRead,BufNewFile *.py set filetype=python
        autocmd FileType python set colorcolumn=80 tabstop=4 shiftwidth=4 noexpandtab nocursorcolumn textwidth=79
augroup END

augroup go
        autocmd BufRead,BufNewFile *.go set filetype=go
        autocmd FileType go set colorcolumn=80 tabstop=4 shiftwidth=4 noexpandtab nocursorcolumn textwidth=79
				"autocmd CursorMoved * call s:ShowDoc()
				"let timer = timer_start(5000, 'ShowDoc', {'repeat': -1})
augroup END

augroup ruby
        autocmd BufRead,BufNewFile *.rb set filetype=ruby
        autocmd FileType ruby set colorcolumn=80 tabstop=8 shiftwidth=8 noexpandtab nocursorcolumn textwidth=79
augroup END

augroup tex
        autocmd BufRead,BufNewFile *.tex set filetype=tex
        autocmd FileType tex set colorcolumn=80 tabstop=4 shiftwidth=4 noexpandtab nocursorcolumn textwidth=79
augroup END

augroup lisp
        autocmd BufRead,BufNewFile *.lisp set filetype=lisp
        autocmd FileType lisp set colorcolumn=120 tabstop=8 shiftwidth=8 noexpandtab nocursorcolumn textwidth=119
				"autocmd FileType lisp let b:delimitMate_autoclose = 0
augroup END

" Adding the time addition shortcut
:nnoremap <F10> "=strftime("%a, %d %b %Y %H:%M:%S %z") . " : "<CR>P
:inoremap <F10> <C-R>=strftime("%a, %d %b %Y %H:%M:%S %z") . " : "<CR>
