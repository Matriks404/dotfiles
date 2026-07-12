" Set spacebar as the leader shortcut key
let mapleader = " "  


" Delete to black hole register (no clipboard overwrite)
vnoremap <leader>d "_d
nnoremap <leader>dd "_dd


" Code indentation and tab spacing rules
set autoindent
set smartindent
set expandtab

set shiftwidth=4
set softtabstop=4
set tabstop=4

filetype plugin indent on


" User interface preferences
set number
set showcmd
set wildmenu


" Search behavior tweaks
set hlsearch
set incsearch
"set ignorecase
"set smartcase
