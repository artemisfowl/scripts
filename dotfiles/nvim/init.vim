" check whether vim-plug is installed and install it if necessary
let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
	if executable('curl')
		let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
		call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
		if v:shell_error
			echom "Error downloading vim-plug. Please install it manually.\n"
			exit
		endif
	else
		echom "vim-plug not installed. Please install it manually or install curl.\n"
		exit
	endif
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go'
Plug 'preservim/nerdtree'
Plug 'flazz/vim-colorschemes'
Plug 'tpope/vim-fugitive'
Plug 'sjl/gundo.vim'
Plug 'rking/ag.vim'
Plug 'godlygeek/tabular'
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'
Plug 'vim-scripts/Tagbar'
Plug 'beloglazov/vim-online-thesaurus'
Plug 'machakann/vim-highlightedyank'
Plug 'gauteh/vim-cppman'
Plug 'flazz/vim-colorschemes'
Plug 'vim-scripts/c.vim'
Plug 'vim-scripts/a.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'google/vim-searchindex'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'chaoren/vim-wordmotion'

call plug#end()

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Remap enter while CocCompletion is open in order to get the recent selection
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"

" remap for complete to use tab and <cr>
inoremap <silent><expr> <TAB>
			\ coc#pum#visible() ? coc#pum#next(1):
			\ <SID>check_back_space() ? "\<Tab>" :
			\ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()

" CocCompletion color
hi CocSearch ctermfg=12 guifg=#18A3FF
hi CocMenuSel ctermbg=109 guibg=#13354A

" -------- General configurartion section --------------------
" Switch on the plugin and indent
filetype plugin indent on

"set the clipboard
set clipboard=unnamed

"set the numbering and other such configurations
syntax enable
set grepprg=grep\ -nH\ $*
set number relativenumber
set nocompatible
set noswapfile

" CtrlP configuration
set runtimepath^=~/.vim/plugged/ctrlp.vim
" For checking files using CtrlP
let g:ctrlp_show_hidden = 1
" Enabling per session caching
let g:ctrlp_use_caching = 1
" Disabling cache clearing on Vim Exit
let g:ctrlp_clear_cache_on_exit = 0
" Setting the directory for saving the caches
let g:ctrlp_cache_dir = $HOME.'/.vim/ctrlp_cache/'

" Powerline symbols - use the fancy ones
let g:Powerline_symbols = "fancy"

"{{{Auto Commands

" Automatically cd into the directory that the file is in
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Restore cursor position to where it was before
augroup JumpCursorOnEdit
	au!
	autocmd BufReadPost *
				\ if expand("<afile>:p:h") !=? $TEMP |
				\   if line("'\"") > 1 && line("'\"") <= line("$") |
				\     let JumpCursorOnEdit_foo = line("'\"") |
				\     let b:doopenfold = 1 |
				\     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
				\        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
				\        let b:doopenfold = 2 |
				\     endif |
				\     exe JumpCursorOnEdit_foo |
				\   endif |
				\ endif
	" Need to postpone using "zv" until after reading the modelines.
	autocmd BufWinEnter *
				\ if exists("b:doopenfold") |
				\   exe "normal zv" |
				\   if(b:doopenfold > 1) |
				\       exe  "+".1 |
				\   endif |
				\   unlet b:doopenfold |
				\ endif
augroup END

"}}}

"{{{Misc Settings
" This shows what you are typing as a command.  I love this!
set showcmd

" Gundo plugin configuration
set undodir=~/.config/nvim/tmp/undo/
set undofile
set history=100
set undolevels=100
if has('python3')
	let g:gundo_prefer_python3 = 1 " For Vim built with -python and +python3
endif

" Vim-session management settings
let g:session_directory = "~/.config/nvim/session"
let g:session_autoload = "no"
let g:session_autosave = "yes"

" Folding Stuffs
" set foldmethod=marker
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1
set tabpagemax=1000

" Who doesn't like autoindent?
set autoindent

" Use english for spellchecking, but don't spellcheck by default
if version >= 700
	set spl=en spell
	set nospell
endif

" Cool tab completion stuff
set wildmenu
set wildmode=list:longest,full

" Enable mouse support in console
set mouse=a

" Got backspace?
set backspace=2

" Ignoring case is a fun trick
set ignorecase

" And so is Artificial Intellegence!
set smartcase

" Enabling Autosave feature with jj - should be rarely used
inoremap jj <Esc>:w<CR>

" Forget about multiple captial J - do no operation if that key is spammed
nnoremap JJJJ <Nop>

" Incremental searching is sexy
set incsearch

" Highlight things that we find with the search
set hlsearch

" Since I use linux, I want this
let g:clipbrdDefaultReg = '+'

" When I close a tab, remove the buffer
set nohidden

" Set off the other paren
highlight MatchParen ctermbg=4
" }}}

"{{{Look and Feel
" Favorite Color Scheme
if has("gui_running")
	"colorscheme osx_like
	colorscheme wombat256mod
	" Remove Toolbar
	set guioptions-=T
	"Terminus is AWESOME
	"set guifont=Anonymous\ Pro\ for\ Powerline\ 12
	"set guifont=Hack\ Regular\ 8
	set guifont=SF\ Mono\ Powerline\ Semibold\ 9
	let g:airline_powerline_fonts=1
	let g:airline_theme='powerlineish'
else
	colorscheme wombat256dave
	"colorscheme holokai
	set t_Co=256
	let g:airline#extensions#tabline#enabled = 1
	let g:airline_powerline_fonts=1
	let g:airline_theme='raven'
	"let g:airline_theme='dark'

endif

"Status line gnarliness
set laststatus=2

" setting the ruler
set ruler

set statusline=%t%m%r%h%w\ %=[%l,%c%V]\ [%p%%]
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

" Function to get the size of the file in bytes
function! FileSize()
	let bytes = getfsize(expand("%:p"))
	if bytes < 0
		return ""
	endif
	if bytes < 1024
		return bytes . "b"
	endif
	if bytes > 1024
		return (bytes / 1024) . "K"
	endif
endfunction

function! HasPaste()
	if &paste
		return 'PASTE MODE  '
	endif
	return ''
endfunction

" }}}

"{{{ Functions

"{{{ Open URL in browser

function! Browser ()
	let line = getline (".")
	let line = matchstr (line, "http[^   ]*")
	exec "!firefox ".line
endfunction

"}}}

"{{{ Paste Toggle
let paste_mode = 0 " 0 = normal, 1 = paste

func! Paste_on_off()
	if g:paste_mode == 0
		set paste
		let g:paste_mode = 1
	else
		set nopaste
		let g:paste_mode = 0
	endif
	return
endfunc
"}}}

"{{{ Todo List Mode

function! TodoListMode()
	e ~/.todo.otl
	Calendar
	wincmd l
	set foldlevel=1
	tabnew ~/.notes.txt
	tabfirst
	" or 'norm! zMzr'
endfunction

"}}}

"}}}

" Key mappings
map <silent> <F4> :NERDTreeToggle<CR>
map! <silent> <F4> <ESC>:NERDTreeToggle<CR>

map <silent> <F2> :GundoToggle<CR>
map! <silent> <F-2> <ESC>:GundoToggle<CR>

" Ag Configuration
let g:ag_prg="/usr/bin/ag --column"

"set listchars=tab:>~,nbsp:_,trail:.
set listchars=trail:.
set nolist
noremap <F6> :set list!<CR>

xnoremap < <gv
xnoremap > >gv

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
	let p = '^\s*|\s.*\s|\s*$'
	if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
		let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
		let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
		Tabularize/|/l1
		normal! 0
		call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
	endif
endfunction

:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78

set cursorline

if has("autocmd")
	"au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
	au InsertEnter * silent execute "!echo -ne \e[6 q"
	"au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
	au InsertLeave * silent execute "!echo -ne \e[2 q"
	"au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
	au InsertLeave * silent execute "!echo -ne \e[2 q"
endif

let g:ctrlp_buffer_func = { 'enter': 'WarFunction' }

func! WarFunction()
	nnoremap <buffer> <silent> <c-@> :call <sid>DeleteBuffer()<cr>
endfunc

func! s:DeleteBuffer()
	let line = getline('.')
	let bufid = line =~ '\[\d\+\*No Name\]$' ? str2nr(matchstr(line, '\d\+'))
				\ : fnamemodify(line[2:], ':p')
	exec "bd" bufid
	exec "norm \<F5>"
endfunc

map H ^
map L $

nnoremap <C-K> :call HighlightNearCursor()<CR>

function! HighlightNearCursor() " Function already exists now, not required explicitly
	if !exists("s:highlightcursor")
		match Todo /\k*\%#\k*/
		let s:highlightcursor=1
	else
		match None
		unlet s:highlightcursor
	endif
endfunction

let s:pattern = '^\(.* \)\([1-9][0-9]*\)$'
let s:minfontsize = 6
let s:maxfontsize = 16
function! AdjustFontSize(amount)
	if has("gui_gtk2") && has("gui_running")
		let fontname = substitute(&guifont, s:pattern, '\1', '')
		let cursize = substitute(&guifont, s:pattern, '\2', '')
		let newsize = cursize + a:amount
		if (newsize >= s:minfontsize) && (newsize <= s:maxfontsize)
			let newfont = fontname . newsize
			let &guifont = newfont
		endif
	else
		echoerr "You need to run the GTK2 version of Vim to use this function."
	endif
endfunction

function! LargerFont()
	call AdjustFontSize(1)
endfunction
command! LargerFont call LargerFont()

function! SmallerFont()
	call AdjustFontSize(-1)
endfunction
command! SmallerFont call SmallerFont()

" Close the preview window when I am out of the edit mode
let g:ycm_autoclose_preview_window_after_insertion = 1

" Airline configuration
"let g:airline_theme='wombat'
"let g:airline#extensions#tabline#enabled = 0
"let g:airline_powerline_fonts=1
"let g:airline_exclude_preview=1


" Some other key mappings for qutting
nnoremap <F5> :redraw!<CR>
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

let g:rustfmt_autosave = 0

" Tagbar configuration
nnoremap <silent> <F7> :Tagbar<CR>

" Jump to shell
nnoremap <silent> <F8> :sh<CR>


let g:tagbar_type_typescript = {
			\ 'ctagstype': 'typescript',
			\ 'kinds': [
			\ 'c:classes',
			\ 'n:modules',
			\ 'f:functions',
			\ 'v:variables',
			\ 'v:varlambdas',
			\ 'm:members',
			\ 'i:interfaces',
			\ 'e:enums',
			\ ]
			\}

" Word Processor mode function
func! WordProcessorMode()
	setlocal smartindent
	setlocal spell spelllang=en_us
endfu

com! WP call WordProcessorMode()

" Tmuxline customization
let g:tmuxline_preset = {
			\'a'    : '%a',
			\'b'    : '#W',
			\'c'    : '#H',
			\'win'  : '#I #W',
			\'cwin' : '#W',
			\'x'    : ['#(~/.tp/tEmpty.sh)', '#(~/.tp/checkBatCapacity.sh)', '#(~/.tp/batPercent.sh)', '#(~/.tp/batStateCheck.sh)'],
			\'y'    : ['%T', '%d %b'],
			\'z'    : ['#(~/.tp/uptimeDisp.sh)',]}
let g:tmuxline_separators = {
			\ 'left' : '',
			\ 'left_alt': '>',
			\ 'right' : '',
			\ 'right_alt' : '<',
			\ 'space' : ' '}

" Putting the OpenSession command to an alias - too much hassle to type this
" big a command
"cnoreabbrev os OpenSession

" Adding Thesaurus mode kepmaps
nnoremap <F9> :OnlineThesaurusCurrentWord<CR>
" Adding git custom command in here
"cnoreabbrev gs Gstatus
"cnoreabbrev gc Gcommit
"cnoreabbrev gp Gpush
"cnoreabbrev gl Gpull
"cnoreabbrev gw Gwrite

" Search down into sub-directories and provide auto-completion for all file
" related tasks
set path+=**

" Update the location list with the error details
let g:ycm_always_populate_location_list = 1

" Make, make clean and the like
let &makeprg = 'if [ -f Makefile ]; then make -C %:p:h $*; else make -C %:p:h/.. $*; fi'
nnoremap <leader>m :silent make!\|redraw!\|cw<CR>

" Open go-doc in a popup window (S-k)
let g:go_doc_popup_window = 1

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
	autocmd FileType python set colorcolumn=120 tabstop=4 shiftwidth=4 noexpandtab nocursorcolumn textwidth=119
augroup END

augroup go
	autocmd BufRead,BufNewFile *.go set filetype=go
	autocmd FileType go set colorcolumn=80 tabstop=4 shiftwidth=4 noexpandtab nocursorcolumn textwidth=79
augroup END

augroup ruby
	autocmd BufRead,BufNewFile *.rb set filetype=ruby
	autocmd FileType ruby set colorcolumn=80 tabstop=8 shiftwidth=8 noexpandtab nocursorcolumn textwidth=79
augroup END

augroup tex
	autocmd BufRead,BufNewFile *.tex set filetype=tex
	autocmd FileType tex set colorcolumn=120 tabstop=4 shiftwidth=4 noexpandtab nocursorcolumn textwidth=119
augroup END

augroup lisp
	autocmd BufRead,BufNewFile *.lisp set filetype=lisp
	autocmd FileType lisp set colorcolumn=120 tabstop=8 shiftwidth=8 noexpandtab nocursorcolumn textwidth=119
	"autocmd FileType lisp let b:delimitMate_autoclose = 0
augroup END

" Adding the time addition shortcut
:nnoremap <F10> "=strftime("%a, %d %b %Y %H:%M:%S %z") . " : "<CR>P
:inoremap <F10> <C-R>=strftime("%a, %d %b %Y %H:%M:%S %z") . " : "<CR>

" Setting up F3 to open a terminal with a vertical split
"set splitright " open the split on the right hand side always
nnoremap <silent> <F3> :vertical terminal<CR>

" More navigation mappings
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Mapping C-b to something else
map <C-d> <C-b>

" Mapping C-m to swap panes - though I rarely use this one
map <C-t> <C-w><C-r>

" removing all bells for the GUI mode only
if has("gui_gtk2") && has("gui_running")
	set belloff=all
endif

" OpenSession command shortcut
"nnoremap <C-H> :OpenSession

" Removing underline from the CursorLineNr
hi CursorLineNr term=bold cterm=bold ctermfg=Yellow gui=bold guifg=Yellow

" Checking the rulerformat
"set rulerformat=%t%=%l,%c%V%=%P

" Mapping key F12 to show the twitter user timeline
nnoremap <F12> :PosttoTwitter<CR>

" Mapping keys for adding line to end and start of file
map <C-o> Go
map <C-u> ggO

let g:ycm_language_server =
			\ [
			\   {
			\     'name': 'gopls',
			\     'cmdline': [ '~/.vim/bundle/YouCompleteMe/third_party/ycmd/third_party/go/bin/gopls' , "-rpc.trace" ],
			\     'filetypes': [ 'go' ],
			\     "project_root_files": [ "go.mod" ]
			\   }
			\ ]

let g:go_def_mode='~/.vim/bundle/YouCompleteMe/third_party/ycmd/third_party/go/bin/gopls'
let g:go_info_mode='~/.vim/bundle/YouCompleteMe/third_party/ycmd/third_party/go/bin/gopls'
" let g:ycm_log_level = 'debug'
set completeopt=longest,menu

" mapping for annoying commands
command W w

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Set up vertical vs block cursor for insert/normal mode
if &term =~ "screen.*"
	let &t_ti.="\eP\e[1 q\e\\"
	let &t_SI.="\eP\e[5 q\e\\"
	let &t_EI.="\eP\e[1 q\e\\"
	let &t_te.="\eP\e[0 q\e\\"
else
	let &t_ti.="\<Esc>[1 q"
	let &t_SI.="\<Esc>[5 q"
	let &t_EI.="\<Esc>[1 q"
	let &t_te.="\<Esc>[0 q"
endif

lua << END
-- stylua: ignore
local colors = {
  blue   = '#80a0ff',
  cyan   = '#79dac8',
  black  = '#080808',
  white  = '#c6c6c6',
  red    = '#ff5189',
  violet = '#d183e8',
  grey   = '#303030',
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.black, bg = colors.black },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.black, bg = colors.black },
  },
}

require('lualine').setup {
  options = {
    theme = moonfly,
    component_separators = '|',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '' }, right_padding = 2 },
    },
    lualine_b = { 'filename', 'branch' },
    lualine_c = { 'fileformat' },
    lualine_x = {},
    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {},
}
END
