" -*- mode: conf -*-

" set compatibility to Vim only
set nocompatible

" helps force plug-ins to load correctly when it is turned back on below
filetype off

" turn on syntax highlighting
syntax on

" for plug-ins to load correctly
filetype plugin indent on

" turn off modelines
set modelines=0

" automatically wrap text that extends beyond the screen length
set wrap

" break lines at word
set linebreak
" set showbreak=+++

" press the <F2> key to toggle paste mode on/off.
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

" display 5 lines above/below the cursor when scrolling with a mouse.
set scrolloff=5

" fixes common backspace problems
set backspace=indent,eol,start

" speed up scrolling in Vim
set ttyfast

" status bar
set laststatus=2

" display options
set showmode
set showcmd

" highlight matching pairs of brackets. Use the '%' character to jump between them.
set matchpairs+=<:>

" display different types of white spaces.
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.

" show line numbers
set number

" set status line display
set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%b\ %d\ /\ %H:%M')}

" set encoding
set encoding=utf-8

" highlight matching search patterns
set hlsearch

" enable incremental search
set incsearch

" include matching uppercase words with lowercase search term
set ignorecase

" include only uppercase words with uppercase search term
set smartcase

" store info from no more than 100 files at a time, 9999 lines of text, 100kb of data.
set viminfo='100,<9999,s100

set textwidth=100
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set smartindent
set noshiftround

" map the <Space> key to toggle a selected fold opened/closed.
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" automatically save and load folds
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview"
