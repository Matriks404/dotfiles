" Set color scheme.
colorscheme habamax


" Enable syntax higlighting.
syntax on


" Set spacebar as the leader shortcut key.
let mapleader = " "  


" Delete to black hole register (no clipboard overwrite).
vnoremap <leader>d "_d
nnoremap <leader>dd "_dd


" Various settings.
set backup
set display+=lastline
set scrolloff=8


" Code indentation and tab spacing rules.
set autoindent
set smartindent
set expandtab

set shiftwidth=4
set softtabstop=4
set tabstop=4

filetype plugin indent on


" User interface preferences.
set number
set showcmd
set wildmenu
set background=dark


" Search behavior tweaks.
set hlsearch
set incsearch
"set ignorecase
"set smartcase


" Persistent undo.
if has('persistent_undo')
    if !isdirectory(expand('~/.vim/undodir'))
        call mkdir(expand('~/.vim/undodir'), 'p')
    endif

    set undodir=~/.vim/undodir
    set undofile
endif


" Centralized swap files.
if !isdirectory(expand('~/.vim/swapdir'))
    call mkdir(expand('~/.vim/swapdir'), 'p')
endif

set directory=~/.vim/swapdir//


" Enable 24-bit RGB true color in terminal.
if has('termguicolors')
    set termguicolors
endif


" Add 'matchit' optional package.
if has ('syntax') && has('eval')
    packadd! matchit
endif
